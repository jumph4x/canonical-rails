require_relative '../../app/helpers/canonical_rails/tag_helper'

module CanonicalRails
  class Engine < ::Rails::Engine

    initializer 'canonical_rails.add_helpers' do |app|
      ActionView::Base.send :include, CanonicalRails::TagHelper
    end

  end
end
