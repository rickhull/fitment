require 'fitment'

module Fitment
  class Wheel
    def self.et(offset_in, width_in)
      (-1 * Fitment.mm(offset_in - width_in / 2)).round
    end

    def self.offset(et_mm, width_in)
      (width_in / 2 - Fitment.inches(et_mm)).round(2)
    end

    attr_reader :diameter, :width, :et
    attr_accessor :bolt_pattern

    def initialize(diameter_in, width_in, et = 0, bolt_pattern: "")
      @diameter = diameter_in
      @width = width_in
      @et = et
      @bolt_pattern = bolt_pattern
    end

    def to_s
      "#{@diameter}x#{@width} ET#{et}  #{@bolt_pattern}".strip
    end

    def offset
      self.class.offset(@et, @width)
    end
  end

  class OffsetWheel < Wheel
    attr_reader :offset

    def initialize(diameter_in, width_in, offset_in, bolt_pattern: "")
      @diameter = diameter_in
      @width = width_in
      @offset = offset_in
      @bolt_pattern = bolt_pattern
    end

    def to_s
      "#{@diameter}x#{@width} #{@offset}\" offset  #{@bolt_pattern}".strip
    end

    def et
      self.class.et(@offset, @width)
    end
  end
end
