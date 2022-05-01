require 'fitment/combo'

FC = Fitment::Combo

stock18 = FC.new_with_params(225, 40, 18, 8, 46)
stock19 = FC.new_with_params(235, 35, 19, 8, 49)
after18 = FC.new_with_params(245, 40, 18, 8, 45)
after19 = FC.new_with_params(245, 35, 19, 8, 49)

puts [stock19.report(after18),
      stock19.report(after19)].join("\n\n")

puts "\n----------"
puts

puts [stock18.report(after18),
      stock18.report(stock19),
      stock18.report(after19)].join("\n\n")
