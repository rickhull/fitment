require 'fitment'
require 'minitest/autorun'

describe Fitment do
  it "has a conversion constant" do
    expect(Fitment::MM_PER_INCH).must_equal 25.4
  end

  it "converts mm to inches and vice versa" do
    expect(Fitment.in 25.4).must_be_within_epsilon 1.0
    expect(Fitment.mm 1).must_equal 25.4
    expect(Fitment.mm 12).must_equal 25.4 * 12
  end
end
