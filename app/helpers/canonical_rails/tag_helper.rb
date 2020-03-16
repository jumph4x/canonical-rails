module CanonicalRails
  module TagHelper
    def trailing_slash_needed?
      request.params.key?('action') && CanonicalRails.sym_collection_actions.include?(request.params['action'].to_sym)
    end

    # Leave force_trailing_slash as nil to get the original behavior of trailing_slash_if_needed
    def trailing_slash_config(force_trailing_slash = nil)
      if force_trailing_slash
        "/"
      elsif force_trailing_slash.nil?
        trailing_slash_if_needed
      end
    end

    def trailing_slash_if_needed
      "/" if trailing_slash_needed?
    end

    def path_without_html_extension
      return '' if request.path == '/'

      request.path.sub(/\.html$/, '')
    end

    def canonical_protocol
      CanonicalRails.protocol || request.protocol
    end

    def canonical_host
      CanonicalRails.host || request.host
    end

    def canonical_port
      (CanonicalRails.port || request.port).to_i
    end

    def canonical_href(host = canonical_host, port = canonical_port, force_trailing_slash = nil)
      default_ports = { 'https://' => 443, 'http://' => 80 }
      port = port.present? && port.to_i != default_ports[canonical_protocol] ? ":#{port}" : ''
      raw "#{canonical_protocol}#{host}#{port}#{path_without_html_extension}#{trailing_slash_config(force_trailing_slash)}#{whitelisted_query_string}"
    end

    def canonical_path(force_trailing_slash = nil)
      raw "#{path_without_html_extension}#{trailing_slash_config(force_trailing_slash)}#{whitelisted_query_string}"
    end

    def canonical_tag(host = canonical_host, port = canonical_port, force_trailing_slash = nil)
      canonical_url = canonical_href(host, port, force_trailing_slash)
      capture do
        if CanonicalRails.opengraph_url
          concat tag(:meta, property: 'og:url', content: canonical_url)
        end
        concat tag(:link, href: canonical_url, rel: :canonical)
      end
    end

    def whitelisted_params
      selected_params = params.select do |key, value|
        value.present? && CanonicalRails.sym_whitelisted_parameters.include?(key.to_sym)
      end

      selected_params.respond_to?(:to_unsafe_h) ? selected_params.to_unsafe_h : selected_params.to_h
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

      wl_params = whitelisted_params

      "?" + Rack::Utils.build_nested_query(convert_numeric_params(wl_params)) if wl_params.present?
    end

    private

    def convert_numeric_params(params_hash)
      Hash[params_hash.map { |k, v| v.is_a?(Numeric) ? [k, v.to_s] : [k, v] }]
    end
  end
end
