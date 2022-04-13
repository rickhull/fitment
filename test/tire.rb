require 'fitment/tire'
require 'minitest/autorun'

T = Fitment::Tire

describe T do
  it "stuff" do
    expect(T.sidewall_height(255, 45)).must_be_kind_of(Numeric)
  end
end
