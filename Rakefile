require 'rake/testtask'

Rake::TestTask.new :test do |t|
  t.pattern = "test/*.rb"
  t.warning = true
end

task default: :test

desc "Run example scripts"
task :examples do
  Dir['examples/**/*.rb'].each { |filepath|
    puts
    sh "ruby -Ilib #{filepath}"
    puts
  }
end

#
# METRICS
#

begin
  require 'flog_task'
  FlogTask.new do |t|
    t.threshold = 400
    t.dirs = ['lib']
    t.verbose = true
  end
rescue LoadError
  warn 'flog_task unavailable'
end

begin
  require 'flay_task'
  FlayTask.new do |t|
    t.threshold = 400
    t.dirs = ['lib']
    t.verbose = true
  end
rescue LoadError
  warn 'flay_task unavailable'
end

begin
  require 'roodi_task'
  RoodiTask.new config: '.roodi.yml', patterns: ['lib/**/*.rb']
rescue LoadError
  warn "roodi_task unavailable"
end

#
# GEM BUILD / PUBLISH
#

begin
  require 'buildar'

  Buildar.new do |b|
    b.gemspec_file = 'fitment.gemspec'
    b.version_file = 'VERSION'
    b.use_git = true
  end
rescue LoadError
  warn "buildar tasks unavailable"
end
