require 'fitment'

Fitment.autoload(:Tire,  'fitment/tire')
Fitment.autoload(:Wheel, 'fitment/wheel')

module Fitment
  module Parse
    class InputError < RuntimeError; end
    class DiameterError < InputError; end
    class WidthError < InputError; end
    class OffsetError < InputError; end
    class ETError < InputError; end
    class RatioError < InputError; end

    MAX_INPUT = 32

    def self.wheel(str)
      raise(InputError, "str.length > #{MAX_INPUT}") if str.length > MAX_INPUT
      # diameter and width: int or float.0 or float.5
      dim_rgx = /\A[1-3]?[0-9](?:\.[05])?\z/
      # offset: +- int or float.0 or float.5
      offset_rgx = /\A[+-]?[1-9]?[0-9](?:\.[05])?\z/
      # et: +- int
      et_rgx = /\A[+-]?[1-9]?[0-9]\z/

      # use split(str, -1) to detect multiple uses of keywords
      parts = str.strip.downcase.split('x', -1).map(&:strip)
      if parts.size != 2
        raise(InputError, "unexpected split on x: #{str} #{parts.inspect}")
      end

      d, rest = *parts
      raise(DiameterError, d) unless d.match dim_rgx

      # check for offset first
      parts = rest.split('offset', -1).map(&:strip)
      case parts.size
      when 2
        # found offset
        raise(WidthError, parts[0]) unless parts[0].match dim_rgx
        raise(OffsetError, parts[1]) unless parts[1].match offset_rgx
        Wheel.new(d, parts[0], offset: parts[1])
      when 1
        # check for et
        parts = rest.split('et', -1).map(&:strip)
        case parts.size
        when 2
          raise(WidthError, parts[0]) unless parts[0].match dim_rgx
          raise(ETError, parts[1]) unless parts[1].match et_rgx
          Wheel.new(d, parts[0], et: parts[1])
        when 1
          # no et or offset, just width
          raise(WidthError, rest) unless rest.match dim_rgx
          Wheel.new(d, rest)
        else
          # hmmm, multiple ets?
          raise(ETError, [rest, parts.inspect].join("\t"))
        end
      else
        # hmmm, multiple offsets?
        raise(OffsetError, [rest, parts.inspect].join("\t"))
      end
    end

    def self.tire(str)
      raise(InputError, "str.length > #{MAX_INPUT}") if str.length > MAX_INPUT
      # width: 105-495
      width_rgx = /\A[1-4][0-9]5\z/

      # aspect ratio: 10-95%
      ratio_rgx = /\A[1-9][05]\z/

      # diameter: int or float.0 or float.5
      dia_rgx = /\A[1-3]?[0-9](?:\.[05])?\z/

      # use split(str, -1) to detect multiple uses of keywords
      parts = str.strip.downcase.split('/', -1).map(&:strip)
      if parts.size != 2
        raise(InputError, "unexpected split on /: #{str} #{parts.inspect}")
      end

      w, rest = *parts
      raise(WidthError, w) unless w.match width_rgx

      # split on R
      parts = rest.split('r', -1).map(&:strip)
      if parts.size != 2
        raise(InputError, "unexpected split on r: #{rest} #{parts.inspect}")
      end

      raise(RatioError, parts[0]) unless parts[0].match ratio_rgx
      raise(DiameterError, parts[1]) unless parts[1].match dia_rgx
      Tire.new(w, parts[0].to_i, parts[1])
    end
  end
end
