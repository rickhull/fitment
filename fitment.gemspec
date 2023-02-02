Gem::Specification.new do |s|
  s.name = 'fitment'
  s.summary = "Simple, fast, and comprehensive wheel and tire fitment analysis"
  s.description = "Use this tool to fill out your fenders and get flush"
  s.authors = ["Rick Hull"]
  s.homepage = "https://github.com/rickhull/fitment"
  s.license = "LGPL-3.0"

  s.required_ruby_version = "> 2"

  s.version = File.read(File.join(__dir__, 'VERSION')).chomp

  s.files = %w[fitment.gemspec VERSION README.md Rakefile]
  s.files += Dir['lib/**/*.rb']
  s.files += Dir['test/**/*.rb']
  s.files += Dir['examples/**/*.rb']
end
