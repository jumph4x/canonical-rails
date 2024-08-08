# frozen_string_literal: true

module CanonicalRails
  class InstallGenerator < Rails::Generators::Base
    def self.source_paths
      paths = []
      paths << File.expand_path('../templates', "../../#{__FILE__}")
      paths << File.expand_path('../templates', "../#{__FILE__}")
      paths << File.expand_path('templates', __dir__)
      paths.flatten
    end

    def add_files
      template 'canonical_rails.rb', 'config/initializers/canonical_rails.rb'
    end
  end
end
