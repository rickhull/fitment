require 'fitment/combo'

FC = Fitment::Combo

stock18 = FC.new_with_params(225, 40, 18, 8, 46)
stock19 = FC.new_with_params(235, 35, 19, 8, 49)
after18 = FC.new_with_params(245, 40, 18, 8, 45)
after19 = FC.new_with_params(245, 35, 19, 8, 49)

puts 'Tire      Wheel     Increase'
puts '----------------------------'
puts [stock19, 'Baseline, Factory 19'].join(' ')
puts [after18, stock19.increase(after18).inspect].join(' ')
puts [after19, stock19.increase(after19).inspect].join(' ')
puts

puts 'Tire      Wheel     Increase'
puts '----------------------------'
puts [stock18, 'Baseline, Factory 18'].join(' ')
puts [after18, stock18.increase(after18).inspect].join(' ')
puts [stock19, stock18.increase(stock19).inspect].join(' ')
puts [after19, stock18.increase(after19).inspect].join(' ')
