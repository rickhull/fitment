require 'fitment/combo'
require 'minitest/autorun'

describe Fitment::Combo do
  FC = Fitment::Combo
  ACTUAL = {
    5.0 => [155, nil, 185],
    8.0 => [225, 245, 275],
    9.5 => [265, 285, 315],
    12.0 => [325, 345, 345],
  }

  it "snaps to industry standard mm widths" do
    expect(FC.snap(254.3)).must_equal 255
    expect(FC.snap(250)).must_equal 255
    expect(FC.snap(249.9)).must_equal 245
    expect(FC.snap(240)).must_equal 245
    expect(FC.snap(239.9)).must_equal 235
  end

  it "uses an :actual tire model" do
    expect(FC.tire_widths(5.0, :actual)).must_equal ACTUAL[5.0]
    expect(FC.tire_widths(8.0, :actual)).must_equal ACTUAL[8.0]
    expect(FC.tire_widths(9.5, :actual)).must_equal ACTUAL[9.5]
    expect(FC.tire_widths(12.0, :actual)).must_equal ACTUAL[12.0]
  end

  it "uses an :extended tire model" do
    expect(FC.tire_widths(5.0, :extended)).must_equal [155, 135, 195]
    expect(FC.tire_widths(8.0, :extended)).must_equal ACTUAL[8.0]
    expect(FC.tire_widths(9.5, :extended)).must_equal [265, 285, 305]
    expect(FC.tire_widths(12.0, :extended)).must_equal [325, 335, 355]
  end

  it "uses a :best tire model" do
    expect(FC.tire_widths(5.0, :best)).must_equal [145, 155, 195]
    expect(FC.tire_widths(8.0, :best)).must_equal ACTUAL[8.0]
    expect(FC.tire_widths(9.5, :best)).must_equal ACTUAL[9.5]
    expect(FC.tire_widths(12.0, :best)).must_equal [325, 355, 375]
  end

  it "uses a :linear tire model" do
    expect(FC.tire_widths(5.0, :linear)).must_equal [145, 155, 205]
    expect(FC.tire_widths(8.0, :linear)).must_equal ACTUAL[8.0]
    expect(FC.tire_widths(9.5, :linear)).must_equal ACTUAL[9.5]
    expect(FC.tire_widths(12.0, :linear)).must_equal [325, 355, 375]
  end

  it "uses a :basic tire model" do
    expect(FC.tire_widths(5.0, :basic)).must_equal [145, 165, 205]
    expect(FC.tire_widths(8.0, :basic)).must_equal ACTUAL[8.0]
    expect(FC.tire_widths(9.5, :basic)).must_equal [265, 275, 315]
    expect(FC.tire_widths(12.0, :basic)).must_equal [325, 345, 375]
  end

  it "uses a :simple tire model" do
    expect(FC.tire_widths(5.0, :simple)).must_equal [145, 165, 205]
    expect(FC.tire_widths(8.0, :simple)).must_equal ACTUAL[8.0]
    expect(FC.tire_widths(9.5, :simple)).must_equal ACTUAL[9.5]
    expect(FC.tire_widths(12.0, :simple)).must_equal [325, 345, 375]
  end
end
