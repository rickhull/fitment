module Fitment
  MM_PER_INCH = 25.4

  def self.in(mm)
    mm.to_f / MM_PER_INCH
  end

  def self.mm(inches)
    inches.to_f * MM_PER_INCH
  end

  # https://www.tiresandco.ca/tire-equivalence-advice.html
  # [min, ideal, ideal, max]
  # this is a simple linear model: y = a + bx; a = 55; b = 20
  # [min, min+10, min+20, min+30]
  def self.tire_widths(rim_width_in)
    Array.new(4) { |i| (55 + 20 * rim_width_in + i * 10).round }
  end
end
