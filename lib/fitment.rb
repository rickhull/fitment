module Fitment
  MM_PER_INCH = 25.4
  TIRE_WIDTH_PARAMS = {
    simple: [20, 40, 75],            # assumes 25.4 slope
    basic: [20.689, 38.467, 74.022], # assumes 25.4 slope
    linear: [[13.222, 26.333],       # r2 = 0.9917
             [12.333, 28.667],       # r2 = 0.9941
             [71.889, 25.667]],      # r2 = 0.9926
  }

  def self.in(mm)
    mm.to_f / MM_PER_INCH
  end

  def self.mm(inches)
    inches.to_f * MM_PER_INCH
  end

  # rounds to e.g. 235, 245, 255, etc. (per industry convention)
  def self.nearest_5(flt)
    ((flt - 5) / 10.0).round * 10 + 5
  end

  # linear model, given a rim width in inches, determine:
  # * minimum tire width in mm
  # * maximum tire width limited to 45% aspect ratio
  # * maximum tire width above 45% aspect ratio (big truck tires)
  def self.tire_widths(rim_width_in, model = :linear)
    TIRE_WIDTH_PARAMS.fetch(model).map { |obj|
      a,b = obj.is_a?(Array) ? obj : [obj, MM_PER_INCH]
      nearest_5(a + b * rim_width_in)
    }
  end
end
