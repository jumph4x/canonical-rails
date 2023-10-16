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
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]

  %w[actionmailer activerecord railties].each do |dep|
    s.add_dependency dep, '>= 4.1', '<= 7.2'
  end

  s.add_dependency "sprockets-rails", '~> 3.0'

  s.add_development_dependency 'appraisal'
  s.add_development_dependency 'rspec-rails', '~> 4.0.1'
  s.add_development_dependency 'pry'
end
