module Fitment
  MM_PER_INCH = 25.4

  def self.in(mm)
    mm.to_f / MM_PER_INCH
  end

  def self.mm(inches)
    inches.to_f * MM_PER_INCH
  end
end
