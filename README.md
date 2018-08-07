CanonicalRails
==============
[![Build Status](https://travis-ci.org/jumph4x/canonical-rails.svg?branch=master)](https://travis-ci.org/jumph4x/canonical-rails)

A number of articles exist explaining the issue concisely and at length:

 *   [Google Webmaster Blog Page About Specifying Canonical](http://googlewebmastercentral.blogspot.com/2009/02/specify-your-canonical.html)
 *   [Google Support About rel="canonical"](http://support.google.com/webmasters/bin/answer.py?hl=en&answer=139394)
 *   [Google Support About Canonicalization](http://support.google.com/webmasters/bin/answer.py?hl=en&answer=139066)

## Guide

Take a look at this blog post that can guide you through the idea and the setup: [Easily add canonical URLs to your Rails app](http://blog.planetargon.com/entries/2014/4/4/easily-add-canonical-urls-to-your-rails-app)

## Challenge

I've seen a lot of folks do more harm by neglecting canonicalization altogether than by applying too narrowly and conservatively, so here is an attempt to let people start modestly without spending too much time on it and whitelist parameters as they need to.

## Install

    gem 'canonical-rails', github: 'jumph4x/canonical-rails'

## Usage

First, generate the config

    rails g canonical_rails:install

Then find it in config/initializers/ as canonical_rails.rb

Finally, include the canonical_tag helper inside the `head` portion of
your HTML views:
```ruby
  <%= canonical_tag -%>
```

## Cred

A project by [Downshift Labs](http://downshiftlabs.com), Ruby on Rails,
Performance tuning and Spree Commerce projects.
