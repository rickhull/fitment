require 'fitment'

module Fitment
  class Tire
    def self.ratio_int(ratio_flt)
      (ratio_flt * 100.0 / 5).round * 5
    end

    # mm
    def self.sidewall_height(width_mm, ratio_flt)
      width_mm * ratio_flt
    end

    # inches
    def self.overall_diameter(width_mm, ratio_flt, wheel_in)
      2 * Fitment.inches(sidewall_height(width_mm, ratio_flt)) + wheel_in
    end

    # the aspect ratio is stored as an integer for easy assignment and
    # comparison, and converted to a float for calculations
    attr_reader :width, :ratio, :wheel_diameter, :series

    def initialize(width_mm, ratio, wheel_in)
      @width = width_mm
      if ratio < 0.99 and ratio > 0.1
        @series = self.class.ratio_int(ratio)
      elsif ratio.is_a? Integer and ratio%5 == 0 and ratio > 10 and ratio < 99
        @series = ratio
      else
        raise("unexpected ratio: #{ratio}")
      end
      @ratio = Rational(@series, 100)
      @wheel_diameter = wheel_in
    end

    def to_s
      [[@width, @series].join('/'), @wheel_diameter].join('R')
    end

    # sidewall height, (mm) and in
    def sh_mm
      self.class.sidewall_height(@width, @ratio).round(1)
    end
    alias_method :sidewall_height, :sh_mm

    def sh_in
      Fitment.inches(sh_mm).round(2)
    end

    # overall diameter, mm and (in)
    def od_in
      self.class.overall_diameter(@width, @ratio, @wheel_diameter).round(2)
    end
    alias_method :overall_diameter, :od_in

    def od_mm
      Fitment.mm(od_in).round(1)
    end

    alias_method(:aspect_ratio, :ratio)
  end
end
