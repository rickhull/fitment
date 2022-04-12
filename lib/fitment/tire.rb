require 'fitment'

module Fitment
  class Tire
    # mm
    def self.sidewall_height(width_mm, ratio_pct)
      width_mm * ratio_pct
    end

    # inches
    def self.overall_diameter(width_mm, ratio_pct, wheel_in)
      2 * Fitment.in(sidewall_height(width_mm, ratio_pct)) + wheel_in
    end

    attr_reader :width, :ratio, :wheel_diameter

    def initialize(width_mm, ratio_pct, wheel_in)
      @width = width_mm
      ratio_pct /= 100.0 if ratio_pct > 1 and ratio_pct <= 100
      @ratio = ratio_pct
      @wheel_diameter = wheel_in
    end

    # sidewall height, (mm) and in
    def sh_mm
      self.class.sidewall_height(@width, @ratio).round(1)
    end
    alias_method :sidewall_height, :sh_mm

    def sh_in
      Fitment.in(sh_mm).round(2)
    end

    # overall diameter, mm and (in)
    def od_in
      self.class.overall_diameter(@width, @ratio, @wheel_diameter).round(2)
    end
    alias_method :overall_diameter, :od_in

    def od_mm
      Fitment.mm(od_in).round(1)
    end
  end
end
