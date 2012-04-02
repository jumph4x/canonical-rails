module CanonicalRails
  class Engine < ::Rails::Engine
    
    initializer 'canonical_rails.add_helpers' do |app|
      ActionView::Base.send :include, CanonicalRails::TagHelper
    end
  
  end
end
