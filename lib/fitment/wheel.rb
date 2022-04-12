require 'fitment'

module Fitment
  class Wheel
    def self.et(offset_in, width_in)
      (-1 * Fitment.mm(offset_in - width_in / 2)).round
    end

    def self.offset(et_mm, width_in)
      (width_in / 2 - Fitment.in(et_mm)).round(2)
    end

    attr_reader :dia, :width, :et, :offset
    attr_accessor :bolt_pattern

    def initialize(diameter_in, width_in, **kwargs)
      @dia = diameter_in
      @width = width_in
      self.et = kwargs[:et] ? kwargs[:et] : 0
      @bolt_pattern = kwargs[:bolt_pattern] ? kwargs[:bolt_pattern] : ""
    end

    def et=(et_mm)
      @et = et_mm
      @offset = self.class.offset(@et, @width)
    end

    def offset=(offset_in)
      @offset = offset_in
      @et = self.class.et(@offset, @width)
    end

    def tire_widths
      TireSize.tire_widths(@width)
    end
  end
end
