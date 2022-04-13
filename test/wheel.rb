require 'fitment/wheel'
require 'minitest/autorun'

W = Fitment::Wheel

describe W do
  it "calculates ET given offset" do
    expect(W.et(3.5, 8)).must_be_kind_of(Numeric)
  end

  it "calculates offset given ET" do
    expect(W.offset(45, 8)).must_be_kind_of(Numeric)
  end

  it "initializes with diameter and width" do
    d,w = 18,8
    wheel = W.new(d, w)
    expect(wheel).must_be_kind_of W
    expect(wheel.diameter).must_equal d
    expect(wheel.width).must_equal w
    expect(wheel.et).must_equal 0
    expect(wheel.bolt_pattern).must_equal ""
  end

  it "initializes with optional et and offset" do
    et = 45
    wet = W.new(17, 7.5, et: et)
    expect(wet).must_be_kind_of W
    expect(wet.et).must_equal et

    offset = 4
    wof = W.new(16, 10, offset: offset)
    expect(wof).must_be_kind_of W
    expect(wof.offset).must_equal offset
  end

  it "initializes with optional bolt_pattern" do
    wbo = W.new(18, 8, bolt_pattern: "5x112")
    expect(wbo).must_be_kind_of W
    expect(wbo.bolt_pattern).must_equal "5x112"
  end
end
