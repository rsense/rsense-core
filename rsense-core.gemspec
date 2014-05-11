# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rsense/core/version'

Gem::Specification.new do |spec|
  spec.name          = "rsense-core"
  spec.version       = Rsense::Core::VERSION
  spec.authors       = ["Eric West", "Tomohiro Matsuyama"]
  spec.email         = ["esw9999@gmail.com", "tomo@cx4a.org"]
  spec.summary       = %q{RSense knows your code.}
  spec.description   = %q{RSense is a tool for doing static analysis of Ruby source code. Rsense-core contains the "library" portion of rsense, as well as the stubs and other artefacts it needs to run.}
  spec.homepage      = ""
  spec.license       = "GPL"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "spoon", "~> 0.0.4"
  spec.add_dependency "jruby-jars", "~> 1.7.4"
  spec.add_dependency "jruby-parser", "~> 0.5.2"
  spec.add_dependency "thor", "~> 0.18.1"

  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-minitest'
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
