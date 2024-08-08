# frozen_string_literal: true

require_relative '../../app/helpers/canonical_rails/tag_helper'

module CanonicalRails
  class Engine < ::Rails::Engine
    initializer 'canonical_rails.add_helpers' do |_app|
      ActionView::Base.include CanonicalRails::TagHelper
    end
  end
end
