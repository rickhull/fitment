require 'minitest/autorun'
require 'fitment/parse'
require 'fitment/wheel'

include Fitment

describe "Parse.wheel" do
  it "recognizes valid inputs" do
    valid = [
      '18x8',
      '18 x 8',
      '14.5x10.5',
      '18 x 8 et 45',
      '18 x 8 offset 4',
      '18x8et-45',
      '18 x 8 et +45',
      '19 x 9.5 offset 4.5',
      '18 X 8',
      '18 X 8 OFFSET -8',
    ]

    valid.each { |input| expect(Parse.wheel(input)).must_be_kind_of Wheel }
  end

  it "requires an X" do
    has_x = ['18x8', '14.5 x 10.5', '19X9', '22.5 X 8.5 ET 27']
    has_x.each { |input| expect(Parse.wheel(input)).must_be_kind_of Wheel }
    no_x = ['abc defg', '18 8', '18 by 8']
    no_x.each { |input|
      expect { Parse.wheel(input) }.must_raise Parse::InputError
    }
  end

  it "validates diameter" do
    bad_d = ['99 x 5', '12.4 x 5', 'abc x defg']
    bad_d.each { |input|
      expect { Parse.wheel(input) }.must_raise Parse::DiameterError
    }
  end

  it "validates width" do
    bad_w = ['18 x 99', '18 x 8.4', '18 x abc']
    bad_w.each { |input|
      expect { Parse.wheel(input) }.must_raise Parse::WidthError
    }
  end

  it "validates offset" do
    bad_o = ['18x8 offset 123.456', '18x8 offset 1 offset 2']
    bad_o.each { |input|
      expect { Parse.wheel(input) }.must_raise Parse::OffsetError
    }
  end

  it "validates ET" do
    bad_e = ['18x8 et 123.456', '18x8 et 1 et']
    bad_e.each { |input|
      expect { Parse.wheel(input) }.must_raise Parse::ETError
    }
  end

  it "rejects junk" do
    junk = ['abc def',
            '18 by 8',
            '18x8 and stuff',
            '18x8 et alot',
            'x' * 1024,
            'x' * 2,
            '10x' * 4,]
    junk.each { |input|
      expect { Parse.wheel(input) }.must_raise Parse::InputError
    }
  end
end
