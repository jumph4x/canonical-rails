# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "canonical-rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "canonical-rails"
  s.version     = CanonicalRails::VERSION
  s.authors     = ["Denis Ivanov"]
  s.email       = ["visible@jumph4x.net"]
  s.homepage    = "https://github.com/jumph4x/canonical-rails"
  s.summary     = "Simple and configurable Rails canonical ref tag helper"
  s.description = "Configurable, but assumes a conservative strategy by default with a goal to solve many search engine index problems: multiple hostnames, inbound links with arbitrary parameters, trailing slashes. "
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["LICENSE", "Rakefile", "README.md"]

  s.add_dependency "actionview", ">= 4.1", "<= 7.2"
end
