# frozen_string_literal: true

require "canonical-rails/engine"
require "canonical-rails/deprecation"

module CanonicalRails
  # Default way to setup CanonicalRails. Run `rails g canonical_rails:install` to create
  # a fresh initializer with all configuration values.
  #
  # the config\setup concept politely observed at and borrowed from Devise: https://github.com/plataformatec/devise/blob/master/lib/devise.rb

  def self.setup
    yield self
  end

  mattr_accessor :host
  @@host = nil

  mattr_accessor :port
  @@port = nil

  mattr_accessor :protocol
  @@protocol = nil

  mattr_accessor :collection_actions
  @@collection_actions = [:index]

  # @deprecated: use config.allowed_parameters instead
  mattr_accessor :whitelisted_parameters
  @@whitelisted_parameters = []

  mattr_accessor :allowed_parameters
  @@allowed_parameters = []

  mattr_accessor :opengraph_url
  @@opengraph_url = false

  def self.sym_collection_actions
    @@sym_collection_actions ||= collection_actions.map(&:to_sym)
  end

  def self.sym_allowed_parameters
    @@sym_allowed_parameters ||= if whitelisted_parameters.empty?
                                   allowed_parameters.map(&:to_sym)
                                 else
                                   CanonicalRails::Deprecation.warn("config.whitelisted_parameters is deprecated, please use config.allowed_parameters instead.")
                                   whitelisted_parameters.map(&:to_sym)
                                 end
  end
end
