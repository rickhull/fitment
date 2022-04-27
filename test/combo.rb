require 'fitment/combo'
require 'minitest/autorun'

describe Fitment::Combo do
  FC = Fitment::Combo

  describe "validating tire width against wheel width" do
    # below should match FC::BY_RIM_WIDTH
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

  describe "real world combo examples" do
    before do
      @stock18 = FC.new_with_params(225, 40, 18, 8, 46)
      @stock19 = FC.new_with_params(235, 35, 19, 8, 49)

      @after18 = FC.new_with_params(245, 40, 18, 8, 45)
      @after19 = FC.new_with_params(245, 35, 19, 8, 49)

      @audi = [@stock18, @stock19, @after18, @after19]
    end

    it "validates the examples" do
      @audi.each { |combo| expect(combo.valid?).must_equal(true) }
    end

    it "has a short box" do
      @audi.each { |combo|
        expect(combo.short_width).must_be(:>, Fitment.mm(combo.wheel.width))
        expect(combo.short_height).must_be(:>,
                                           Fitment.mm(combo.wheel.diameter))
      }
    end

    it "has a tall box" do
      @audi.each { |combo|
        expect(combo.tall_width).must_equal(combo.tire.width)
        expect(combo.tall_height).must_equal(combo.tire.od_mm)
      }
    end

    it "calculates dimensional increase for a new combo" do
      new_18 = @stock19.increase(@after18)

      new_18_wheel = new_18.fetch(:wheel)
      expect(new_18_wheel).must_be_kind_of Array
      expect(new_18_wheel.length).must_equal 3
      expect(new_18_wheel[0]).must_be(:<, 0) # smaller et, more inner clearance
      expect(new_18_wheel[1]).must_be(:>, 0) # smaller et, less outer clearance
      expect(new_18_wheel[2]).must_be(:<, 0) # smaller diameter wheel

      new_18_tire = new_18.fetch(:tire)
      expect(new_18_tire).must_be_kind_of Array
      expect(new_18_tire.length).must_equal 3
      expect(new_18_tire[0]).must_be(:>, 0) # wider tire outweighs smaller et
      expect(new_18_tire[1]).must_be(:>, 0) # wider tire and smaller et
      expect(new_18_tire[1]).must_be(:>, new_18_tire[0]) # smaller et
      expect(new_18_tire[2]).must_be(:>, 0) # big aspect ratio

      new_19 = @stock19.increase(@after19)

      new_19_wheel = new_19.fetch(:wheel)
      expect(new_19_wheel).must_be_kind_of Array
      expect(new_19_wheel.length).must_equal 3
      expect(new_19_wheel[0]).must_be_within_epsilon(0.0) # same wheel
      expect(new_19_wheel[1]).must_be_within_epsilon(0.0) # same wheel
      expect(new_19_wheel[2]).must_be_within_epsilon(0.0) # same wheel

      new_19_tire = new_19.fetch(:tire)
      expect(new_19_tire).must_be_kind_of Array
      expect(new_19_tire.length).must_equal 3
      expect(new_19_tire[0]).must_be(:>, 0) # wider tire, same et
      expect(new_19_tire[1]).must_be(:>, 0) # wider tire, same et
      expect(new_19_tire[2]).must_be(:>, 0) # same aspect ratio on wider tire
    end
  end
end
