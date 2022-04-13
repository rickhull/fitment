require 'fitment/tire'
require 'minitest/autorun'

T = Fitment::Tire

describe T do
  before do
    @w = 245
    @r = 0.35
    @d = 18
    @t = T.new(@w, @r, @d)
    @sh_mm = 85.8
    @od_in = 24.75
  end

  it "calculates sidewall height" do
    expect(T.sidewall_height(255, 0.45)).must_be_within_epsilon 255 * 0.45
    expect(T.sidewall_height(195, 0.55)).must_be_within_epsilon 195 * 0.55
  end

  it "calculates overall diameter" do
    expect(T.overall_diameter(255, 0.45, 17)
          ).must_be_within_epsilon 26.03543307086614
    expect(T.overall_diameter(255, 0.45, 18)
          ).must_be_within_epsilon 27.03543307086614
  end

  it "initializes with width, ratio, and wheel diameter" do
    expect(@t).must_be_kind_of(T)
    expect(@t.width).must_equal @w
    expect(@t.ratio).must_equal @r
    expect(@t.wheel_diameter).must_equal @d
  end

  it "intializes with ratio between 1 and 100" do
    t = T.new(225, 35, 18)
    expect(t).must_be_kind_of(T)
    expect(t.ratio).must_equal 0.35
  end

  it "has a sidewall height in mm and inches" do
    expect(@t.sidewall_height).must_equal @sh_mm
    expect(@t.sh_mm).must_equal @sh_mm
    expect(@t.sh_in).must_be(:<, @sh_mm)
  end

  it "has an overall diameter in mm and inches" do
    expect(@t.overall_diameter).must_equal @od_in
    expect(@t.od_in).must_equal @od_in
    expect(@t.od_mm).must_be(:>, @od_in)
  end
end
