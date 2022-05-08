require 'fitment/combo'
require 'fitment/parse'
require 'yaml'

YAML.load_file('examples/combos.yaml').each { |name, combos|
  puts name
  puts '-' * 8

  combos.each { |hsh|
    puts "%s %s" % [Fitment::Parse.tire(hsh.fetch "tire"),
                    Fitment::Parse.wheel(hsh.fetch "wheel")]
  }
  puts
}
