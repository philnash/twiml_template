# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'twiml_template/version'

Gem::Specification.new do |spec|
  spec.name                   = "twiml_template"
  spec.version                = TwimlTemplate::VERSION
  spec.authors                = ["Phil Nash"]
  spec.email                  = ["philnash@gmail.com"]
  spec.summary                = %q{TwiML templates for Rails and Tilt.}
  spec.description            = %q{An easy way to work with TwiML for responding to Twilio webhooks in Rails or Sinatra applications using template files.}
  spec.homepage               = "https://github.com/philnash/twiml_template"
  spec.license                = "MIT"

  spec.files                  = `git ls-files -z`.split("\x0")
  spec.executables            = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files             = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths          = ["lib"]
  spec.required_ruby_version  = '>= 1.9.3'

  spec.add_dependency "tilt", ">= 1.3", "<= 2.0.4"
  spec.add_dependency "twilio-ruby", ">= 3.0", "< 5.0"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "sinatra", ">= 1.3"
end
