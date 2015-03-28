module CanonicalRails
  module TagHelper

    def trailing_slash_needed?
      CanonicalRails.sym_collection_actions.include? request.params['action'].to_sym
    end

    def trailing_slash_if_needed
      "/" if trailing_slash_needed? and request.path != '/'
    end

    def path_without_html_extension
      request.path.sub(/\.html$/, '')
    end

    def canonical_protocol
      CanonicalRails.protocol || request.protocol
    end

    def canonical_host
      CanonicalRails.host || request.host
    end

    def canonical_href(host=canonical_host)
      raw "#{canonical_protocol}#{host}#{path_without_html_extension}#{trailing_slash_if_needed}#{whitelisted_query_string}"
    end

    def canonical_tag(host=canonical_host)
      tag(:link, :href => canonical_href(host), :rel => 'canonical')
    end

    def whitelisted_params
      request.params.select do |key, value|
        value.present? and
        CanonicalRails.sym_whitelisted_parameters.include? key.to_sym
      end
    end

    def whitelisted_query_string
      # Rack 1.4.5 fails to handle params that are not strings
      # So if
      #     my_hash = { "a" => 1, "b" => 2}
      # Rack::Utils.build_nested_query(my_hash) would return
      #     "a&b"
      # Rack 1.4.5 did not have a test case for this scenario
      # https://github.com/rack/rack/blob/9939d40a5e23dcb058751d1029b794aa2f551900/test/spec_utils.rb#L222
      # Rack 1.6.0 has it
      # https://github.com/rack/rack/blob/65a7104b6b3e9ecd8f33c63a478ab9a33a103507/test/spec_utils.rb#L251

      "?" + Rack::Utils.build_nested_query(Hash[whitelisted_params.map{|k,v| v.is_a?(Numeric) ? [k,v.to_s] : [k,v]}]) if whitelisted_params.present?
    end
  end
end
