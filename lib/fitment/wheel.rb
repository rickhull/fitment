require 'fitment'

module Fitment
  class Wheel
    def self.et(offset_in, width_in)
      (-1 * Fitment.mm(offset_in - width_in / 2)).round
    end

    def self.offset(et_mm, width_in)
      (width_in / 2 - Fitment.inches(et_mm)).round(2)
    end

    attr_reader :diameter, :width
    attr_accessor :bolt_pattern

    def initialize(diameter_in, width_in, bolt_pattern: "", et: 0, offset: nil)
      @diameter = Rational(diameter_in)
      @width = Rational(width_in)
      if offset
        @et = nil
        @offset = Rational(offset)
      else
        @offset = nil
        @et = et.to_i
      end
      @bolt_pattern = bolt_pattern.to_s.strip
    end

    def et
      @et or self.class.et(@offset, @width)
    end

    def offset
      @offset or self.class.offset(@et, @width)
    end

    def et?
      @et
    end

    def offset?
      @offset
    end

    def to_s
      ary = ["%gx%g" % [@diameter, @width]]
      if @offset
        ary << "offset:%g" % @offset
      else
        ary << "et:%i" % @et
      end
      ary.join(' ')
    end
  end

  class ETWheel < Wheel
    def initialize(d, w, et = 0, bolt_pattern: "")
      super(d, w, et: et, bolt_pattern: bolt_pattern)
    end
  end

  class OffsetWheel < Wheel
    def initialize(d, w, offset_in, bolt_pattern: "")
      super(d, w, offset: offset_in, bolt_pattern: bolt_pattern)
    end
  end
end
