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

  # Monkey patch here because flay doesn't respect dirs anymore
  # created mostly by adam12 in #ruby on Libera.Chat

  module FlayTaskExt
    def define
      desc "Analyze for code duplication in: #{dirs.join(", ")}"
      task name do
        require "flay"
        flay = Flay.run(dirs)
        flay.report if verbose

        raise "Flay total too high! #{flay.total} > #{threshold}" if
          flay.total > threshold
      end
      self
    end
  end

  FlayTask.prepend(FlayTaskExt)

  FlayTask.new do |t|
    t.threshold = 100
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
