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
      @diameter = Rational(diameter_in)
      @width = Rational(width_in)
      @et = et.to_i
      @bolt_pattern = bolt_pattern.to_s.strip
    end

    def offset
      self.class.offset(@et, @width)
    end

    def to_s
      "%gx%g ET%i %s" % [@diameter, @width, @et, @bolt_pattern]
    end
  end

  class OffsetWheel < Wheel
    attr_reader :offset

    def initialize(diameter_in, width_in, offset_in, bolt_pattern: "")
      @diameter = Rational(diameter_in)
      @width = Rational(width_in)
      @offset = Rational(offset_in)
      @bolt_pattern = bolt_pattern.to_s.strip
    end

    def et
      self.class.et(@offset, @width)
    end

    def to_s
      "%gx%g offset %g %s" % [@diameter, @width, @offset, @bolt_pattern]
    end
  end
end
