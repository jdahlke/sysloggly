$:.push File.expand_path('../lib', __FILE__)
require 'sysloggly/version'

Gem::Specification.new do |s|
  s.name        = 'sysloggly'
  s.version     = Sysloggly::VERSION
  s.authors     = ['Joergen Dahlke']
  s.email       = ['joergen.dahlke@gmail.de']
  s.homepage    = 'https://github.com/jdahlke/sysloggly'
  s.summary     = %q{Lograge and Syslog integration for Rails apps.}
  s.description = %q{Lograge and Syslog integration for Rails apps.}

  s.rubyforge_project = 'bima-loggly'

  s.files         = `git ls-files -- lib/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  # specify any dependencies here:
  s.add_dependency 'lograge'
  s.add_dependency 'syslogger'

  # specify any development dependencies here:
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rake'
end
