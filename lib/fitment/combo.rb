require 'fitment/wheel'
require 'fitment/tire'

module Fitment
  module Combo
    # https://www.tyresizecalculator.com/charts/tire-width-for-a-wheel-rim-size-chart
    # we'll go from 6" to 10" rim width, with emphasis on 7" to 9"
    # a set of 3 tire widths for each rim width: min, max45, max
    # max45 is the maximum width listed at 45% aspect ratio (no higher)

    BY_RIM_WIDTH = [
      [6.0, 175, 185, 225],
      [6.5, 195, 195, 235],
      [7.0, 195, 215, 255],
      [7.5, 205, 225, 265],
      [8.0, 225, 245, 275],
      [8.5, 235, 255, 295],
      [9.0, 255, 275, 305],
      [9.5, 255, 285, 315],
      [10.0, 275, 295, 295],
    ]

    # my edits for smoothness / continuity
    # corrections for likely data anomalies
    BY_RIM_WIDTH[1][1] = 185 # not 195
    BY_RIM_WIDTH[7][1] = 265 # not 255
    BY_RIM_WIDTH[8][3] = 325 # not 295

    TRANSPOSED = BY_RIM_WIDTH.transpose

    RIM_WIDTHS = TRANSPOSED[0]
    MIN_TIRE_WIDTHS = TRANSPOSED[1]
    MAX45_TIRE_WIDTHS = TRANSPOSED[2]
    MAX_TIRE_WIDTHS = TRANSPOSED[3]

    #
    # Determined via CompSci gem: CompSci::Fit.best(xs, ys)
    #

    # r2 = 0.9917
    MIN_MODEL = :linear  # y = a + bx
    MIN_A = 13.222
    MIN_B = 26.333

    # r2 = 0.9943
#    MAX45_MODEL = :power # y = ax^b
#    MAX45_A = 33.389
#    MAX45_B = 0.95213

    # r2 = 0.9941
    MAX45_MODEL = :linear  # y = a + bx
    MAX45_A = 12.333
    MAX45_B = 28.667

    # r2 = 0.9939
#    MAX_MODEL = :power
#    MAX_A = 59.621
#    MAX_B = 0.74025

    # r2 = 0.9926
    MAX_MODEL = :linear  # y = a + bx
    MAX_A = 71.889
    MAX_B = 25.667

    def self.nearest_5(flt)
      ((flt - 5) / 10.0).round * 10 + 5
    end

    def self.tire_widths(rim_width_in)
      require 'compsci/fit'

      [CompSci::Fit.predict(MIN_MODEL, MIN_A, MIN_B, rim_width_in),
       CompSci::Fit.predict(MAX45_MODEL, MAX45_A, MAX45_B, rim_width_in),
       CompSci::Fit.predict(MAX_MODEL, MAX_A, MAX_B, rim_width_in)].map { |n|
        nearest_5(n)
      }
    end

    def self.min_tire_width(rim_width_in)
      nearest_5(MIN_A + MIN_B * rim_width_in)
    end

    def self.max45_tire_width(rim_width_in)
      nearest_5(MAX45_A * rim_width_in ** MAX45_B)
    end

    def self.max_tire_width(rim_width_in)
      nearest_5(MAX_A * rim_width_in ** MAX_B)
    end

    def self.xtire_widths(rim_width_in)
      [min_tire_width(rim_width_in),
       max45_tire_width(rim_width_in),
       max_tire_width(rim_width_in),
      ]
    end
  end
end
