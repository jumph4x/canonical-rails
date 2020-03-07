$:.push File.expand_path("../lib", __FILE__)

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

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency 'rails', '>= 4.1', '< 6.1'

  s.add_development_dependency 'appraisal'
  s.add_development_dependency "sprockets", '~> 3.0'
  s.add_development_dependency 'rspec-rails', '~> 3.5'
  s.add_development_dependency 'pry'
end
