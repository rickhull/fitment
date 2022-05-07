require 'fitment'
require 'minitest/autorun'

describe Fitment do
  it "has a conversion constant" do
    expect(Fitment::MM_PER_INCH).must_equal 25.4
  end

  it "converts mm to inches and vice versa" do
    expect(Fitment.inches 25.4).must_be_within_epsilon 1.0
    expect(Fitment.mm 1).must_equal 25.4
    expect(Fitment.mm 12).must_equal 25.4 * 12
  end

  it "has a simple linear tire to wheel fitment model" do
    # from https://www.tiresandco.ca/tire-equivalence-advice.html
    src_data = {
      6.0 => [175, 185, 195, 205],
      8.5 => [225, 235, 245, 255],
      12.5 => [305, 315, 325, 335],
    }

    src_data.each { |rim_width, tire_widths|
      expect(Fitment.tire_widths(rim_width)).must_equal tire_widths
    }
  end
end
