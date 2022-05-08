[![CI Status](https://github.com/rickhull/fitment/actions/workflows/ci.yaml/badge.svg)](https://github.com/rickhull/fitment/actions/workflows/ci.yaml)
[![Gem Version](https://badge.fury.io/rb/fitment.svg)](http://badge.fury.io/rb/fitment)

# Fitment

This is a library and utility for analyzing and comparing common wheel and
tire sizes for passenger cars, across most of the globe, but primarily
considering North America, Europe, Japan, and Korea.  Its validity may extend
somewhat towards passenger trucks and other sorts of utility vehicles.

## Wheels

Wheel diameters are expected to mostly conform to whole inch measurements.
Half-inch measurements are acceptable but expected to be rare.  **This library
*does not* expect wheel diameters measured in metric units.**

Wheel widths are expected in half-inch increments, measured in inches.
Expect limited support for wheel widths below 4 inches or above 16 inches.

The location of the hub interface, measured via either "ET" or "offset" is
also required.  "ET" is the most common standard for passenger cars, though
(particularly American) truck wheels and other rear wheel drive platform
wheels may come specified with an "offset" rather than "ET".

### ET

*ET* is measured in millimeters from the centerline of the wheel, and may be
positive or negative.  +55 to -55 is common, with positive ETs associated with
FWD cars (hub towards the outside of the wheel) and negative ETs associated
with RWD cars (hub towards the inside of the wheel).

### Offset

*Offset* is measured in inches from the outside of the wheel, and is nearly
always positive, though it may be negative, meaning the hub interface extends
outside beyond the rim.

## Tires

TBD
