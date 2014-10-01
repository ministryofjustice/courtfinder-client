# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'courtfinder/client/version'

Gem::Specification.new do |spec|
  spec.name          = "courtfinder-client"
  spec.version       = Courtfinder::Client::VERSION
  spec.authors       = ["Aleksandar Simić"]
  spec.email         = ["alex.simic@digital.justice.gov.uk"]
  spec.summary       = %q{Courtfinder client gem}
  spec.description   = %q{https://courttribunalfinder.service.gov.uk/ API client}
  spec.homepage      = "https://github.com/ministryofjustice/courtfinder-client"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.3"
  spec.add_development_dependency "rspec", "~> 3.1"
  spec.add_development_dependency "webmock", "~> 1.18"
  spec.add_development_dependency "faraday", "~> 0.9"
end
