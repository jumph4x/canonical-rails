CanonicalRails
==============

This project rocks and uses MIT-LICENSE, foh sho. Works with rails 3 and 4.

See The [Google Webmaster Blog Page About Specifying Canonical](http://googlewebmastercentral.blogspot.com/2009/02/specify-your-canonical.html) or the [Google Support About rel="canonical"](http://support.google.com/webmasters/bin/answer.py?hl=en&answer=139394) as a primer. 

## Challenge

I've seen a lot of folks do more harm by neglecting canonicalization altogether than by applying to narrowly and conservatively, so here is an attempt to let people start modeslty without spending too much time on it and whitelist parameters as they need to.

## Install

    gem 'canonical-rails', :git => 'git://github.com/jumph4x/rails-canonical.git'
    
## Usage

First, generate the config

    rails g canonical_rails:install
  
Then find it in config/initializers/ as canonical_rails.rb

Finally, include the canonical_tag helper in your views.
