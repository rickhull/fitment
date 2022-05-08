require 'fitment/wheel'
require 'minitest/autorun'

include Fitment

describe Wheel do
  it "calculates ET given offset" do
    expect(Wheel.et(3.5, 8)).must_be_kind_of(Numeric)
  end

  it "calculates offset given ET" do
    expect(Wheel.offset(45, 8)).must_be_kind_of(Numeric)
  end

  it "initializes with diameter and width" do
    d,w = 18,8
    wheel = Wheel.new(d, w)
    expect(wheel).must_be_kind_of Wheel
    expect(wheel.diameter).must_equal d
    expect(wheel.width).must_equal w
    expect(wheel.et).must_equal 0
  end

  it "initializes with optional ET" do
    d,w,et = 18,8,35
    wet = Wheel.new(d, w, et: et)
    expect(wet).must_be_kind_of Wheel
    expect(wet.et).must_equal et
  end

  it "initializes with optional offset" do
    d,w,offset = 20,9,6
    wof = Wheel.new(d, w, offset: offset)
    expect(wof).must_be_kind_of Wheel
    expect(wof.offset).must_equal offset
    expect(wof.et).must_be_nil
  end
end
