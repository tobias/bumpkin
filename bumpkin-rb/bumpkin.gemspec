# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bumpkin/version'

Gem::Specification.new do |spec|
  spec.name          = "bumpkin"
  spec.version       = Bumpkin::VERSION
  spec.authors       = ["Toby Crawley"]
  spec.email         = ["toby@tcrawley.org"]
  spec.summary       = %q{Bumpkin, implemented in Ruby.}
  spec.description   = %q{Bumpkin, implemented in Ruby.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "parslet", "~> 1.5"
  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake", "~> 10.1"
end
