lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "sysloggly/version"

Gem::Specification.new do |spec|
  spec.name        = "sysloggly"
  spec.version     = Sysloggly::VERSION
  spec.licenses    = ["MIT"]
  spec.authors     = ["Joergen Dahlke"]
  spec.email       = ["joergen.dahlke@gmail.com"]

  spec.homepage    = "https://github.com/jdahlke/sysloggly"
  spec.summary     = %q{Lograge and Syslog integration for Rails apps.}
  spec.description = %q{Lograge and Syslog integration for Rails apps.}

  spec.rubyforge_project = "sysloggly"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]


  # specify any dependencies here:
  spec.required_ruby_version = "~> 2.0"
  spec.add_runtime_dependency "multi_json"
  spec.add_runtime_dependency "lograge"

  # specify any development dependencies here:
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rake"
end
