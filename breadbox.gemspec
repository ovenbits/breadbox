# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'breadbox/version'

Gem::Specification.new do |spec|
  spec.name          = "breadbox"
  spec.version       = Breadbox::VERSION
  spec.authors       = ["Nathaniel Watts"]
  spec.email         = ["reg@nathanielwatts.com"]
  spec.summary       = "An interface for uploading to Dropbox or Amazon S3."
  spec.description   = "This gem is just to provide some niceties for uploading with the DropBox and Amazon SDKs."
  spec.homepage      = "https://github.com/ovenbits/breadbox"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "dropbox-sdk", "~> 1.6.4"
  spec.add_dependency "aws-sdk", "~> 2.1.7"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.1"
  spec.add_development_dependency "pry", "~> 0.10"
end
