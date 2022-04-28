require 'fitment'

Fitment.autoload :Tire, 'fitment/tire'
Fitment.autoload :Wheel, 'fitment/wheel'
Fitment.autoload :OffsetWheel, 'fitment/wheel'

module Fitment
  class Combo
    class ValidationError < RuntimeError; end
    class DiameterMismatch < ValidationError; end
    class WidthMismatch < ValidationError; end
    class MinError < WidthMismatch; end
    class Max45Error < WidthMismatch; end
    class MaxError < WidthMismatch; end

    # we'll go from 6" to 10" rim width, with emphasis on 7" to 9"
    # a set of 3 tire widths for each rim width: min, max45, max
    # max45 is the maximum width listed at 45% aspect ratio (no higher)
    # data below is from https://www.tyresizecalculator.com
    # path: /charts/tire-width-for-a-wheel-rim-size-chart
    BY_RIM_WIDTH = [[6.0, 175, 185, 225],
                    [6.5, 195, 195, 235],
                    [7.0, 195, 215, 255],
                    [7.5, 205, 225, 265],
                    [8.0, 225, 245, 275],
                    [8.5, 235, 255, 295],
                    [9.0, 255, 275, 305],
                    [9.5, 255, 285, 315],
                    [10.0, 275, 295, 295]]

    BELOW_6 = [[3.5, 125, nil, 135],
               [4.0, 135, nil, 145],
               [4.5, 145, nil, 165],
               [5.0, 155, nil, 185],
               [5.5, 165, 165, 205]]

    ABOVE_10 = [[10.5, 285, 315, 315],
                [11.0, 305, 315, 345],
                [11.5, 315, 335, 345],
                [12.0, 325, 345, 345],
                [12.5, 345, 345, 345],
                [13.0, 355, 355, 355]]

    # smoothness / continuity corrections for likely data anomalies
    BY_RIM_WIDTH[1][1] = 185 # not 195
    BY_RIM_WIDTH[7][1] = 265 # not 255
    BY_RIM_WIDTH[8][3] = 325 # not 295
    ABOVE_10[0][3] = 335     # not 315

    #
    # Now, let's model the above table with equations
    # For every x (rim width inches), we have 3 ys (tire width millimeters)
    # min, max45, max
    #

    MODELS = {
      # Linear: y = a + bx (or: mx + b)
      simple: [20, 40, 75],            # assume 25.4 slope
      basic: [20.689, 38.467, 74.022], # assume 25.4 slope
      linear: [[13.222, 26.333],       # r2 = 0.9917
               [12.333, 28.667],       # r2 = 0.9941
               [71.889, 25.667]],      # r2 = 0.9926
    }
    # Determined via CompSci gem: CompSci::Fit.best(xs, ys)
    MODELS[:best] = [[:linear, *MODELS[:linear][0]], # r2 = 0.9917; y = a + bx
                     [:power, 33.389, 0.95213],      # r2 = 0.9943; y = ax^b
                     [:power, 59.621, 0.74025]]      # r2 = 0.9939; y = ax^b
    # uses BELOW_6 and ABOVE_10
    MODELS[:extended] = [[:linear,       30.165, 24.647], # r2 = 0.9954
                         [:logarithmic, -229.62, 228.82], # r2 = 0.9951
                         [:logarithmic, -103.60, 183.05]] # r2 = 0.9908

    # rounds to e.g. 235, 245, 255, etc. (per industry convention)
    def self.snap(flt)
      ((flt - 5) / 10.0).round * 10 + 5
    end

    # linear model, given a rim width in inches, determine:
    # * minimum tire width in mm
    # * maximum tire width limited to 45% aspect ratio
    # * maximum tire width above 45% aspect ratio (big truck tires)
    # * models: :actual, :simple, :basic, :linear, :best, :extended
    def self.tire_widths(rim_width_in, model = :actual)
      if model == :actual
        (BY_RIM_WIDTH + BELOW_6 + ABOVE_10).each { |row|
          return row[1..3] if rim_width_in == row[0]
        }
        raise("no match for model :actual, width #{rim_width_in}")
      end
      params = MODELS.fetch(model)
      case model
      when :simple, :basic
        b = MM_PER_INCH
        params.map { |a| snap(a + b * rim_width_in) }
      when :linear
        params.map { |(a, b)| snap(a + b * rim_width_in) }
      when :best, :extended
        params.map { |(model, a, b)|
          snap(case model
               when :logarithmic
                 a + b * Math.log(rim_width_in)
               when :linear
                 a + b * rim_width_in
               when :power
                 a * rim_width_in ** b
               else
                 raise("unknown model: #{model}")
               end)
        }
      else
        raise("unknown model: #{model}")
      end
    end

    def self.new_with_params(tread_with, ratio, diameter, width, offset,
                             et: true)
      tire = Tire.new(tread_with, ratio, diameter)
      wheel = et ?
                Wheel.new(diameter, width, offset) :
                OffsetWheel.new(diameter, width, offset)
      Combo.new(wheel: wheel, tire: tire)
    end

    def self.new_with_offset(t, r, d, w, o)
      self.new_with_params(t, r, d, w, o, et: false)
    end

    TIRE_EXCESS = 15 # extra rubber material near the bead relevant to fitment

    attr_accessor :tire, :wheel, :model

    def initialize(tire:, wheel:, model: :actual)
      @tire = tire
      @wheel = wheel
      @model = model
    end

    def to_s
      [@tire, @wheel].join(' ')
    end

    def validate_diameter!
      wd, twd = @wheel.diameter, @tire.wheel_diameter
      raise(DiameterMismatch, "wheel: %i; tire: %i" % [wd, twd]) if wd != twd
      true
    end

    def validate_width!
      msg = "tire width %i %s %s %i for wheel width %i"

      min, max45, max = self.class.tire_widths(@wheel.width, @model)
      raise(MinError, "no min available for width %i" % @wheel.width) if !min
      if @tire.width < min
        raise(MinError, msg % [@tire.width, '<', 'min', min, @wheel.width])
      end
      if max45 and @tire.ratio <= 45 and @tire.width > max45
        raise(Max45Error, msg % [@tire.width, '>', 'max45', max45, @wheel.width])
      end
      raise(MaxError, "no max available for width %i" % @wheel.width) if !max
      if @tire.width > max
        raise(MaxError, msg % [@tire.width, '>', 'max', max, @wheel.width])
      end
      true
    end

    def validate!
      validate_diameter!
      validate_width!
    end

    def short_width
      Fitment.mm(@wheel.width) + TIRE_EXCESS * 2
    end

    def short_height
      Fitment.mm(@wheel.diameter) + TIRE_EXCESS * 2
    end

    def short_box
      [short_width.round(2), short_height.round(2)]
    end

    def tall_width
      @tire.width
    end

    def tall_height
      @tire.od_mm
    end

    def tall_box
      [tall_width.round(2), tall_height.round(2)]
    end

    def bounding_box
      [[short_width, tall_width].max,
       [short_height, tall_height].max,]
    end

    # returns [inside increase, outside increase, diameter increase] for each
    # of :wheel and :tire
    #
    def increase(other)
      short_width_increase = other.short_width - self.short_width
      short_height_increase = other.short_height - self.short_height
      tall_width_increase = other.tall_width - self.tall_width
      tall_height_increase = other.tall_height - self.tall_height

      # smaller et on other wheel moves it outside; more inside clearance
      et_decrease = self.wheel.et - other.wheel.et

      halfwidth = short_width_increase * 0.5
      wheel = [halfwidth - et_decrease, # inner expansion
               halfwidth + et_decrease, # outer expansion
               short_height_increase]   # height increase

      halfwidth = tall_width_increase * 0.5
      tire = [halfwidth - et_decrease,  # inside expansion
              halfwidth + et_decrease,  # outside expansion
              tall_height_increase]     # height increase

      { wheel: wheel.map { |flt| flt.round(2) },
        tire: tire.map { |flt| flt.round(2) }, }
    end
    alias_method(:clearance, :increase)
  end
end
