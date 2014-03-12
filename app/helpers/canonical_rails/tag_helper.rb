module CanonicalRails
  module TagHelper
    require 'cgi'

    def trailing_slash_needed?
      CanonicalRails.sym_collection_actions.include? request.params['action'].to_sym
    end

    def trailing_slash_if_needed
      "/" if trailing_slash_needed? and request.path != '/'
    end

    def path_without_html_extension
      request.path.sub(/\.html$/, '')
    end

    def canonical_host
      CanonicalRails.host || request.host
    end

    def canonical_href(host=canonical_host)
      "#{request.protocol}#{host}#{path_without_html_extension}#{trailing_slash_if_needed}#{whitelisted_query_string}"
    end

    def canonical_tag(host=canonical_host)
      tag(:link, :href => raw(canonical_href(host)), :rel => 'canonical')
    end

    def whitelisted_params
      request.params.select do |key, value|
        value.present? and
        CanonicalRails.sym_whitelisted_parameters.include? key.to_sym
      end
    end

    def whitelisted_query_string
      "?#{whitelisted_params.map{ |key, val| "#{CGI.escape(key)}=#{CGI.escape(val)}" }.join('&')}" if whitelisted_params.present?
    end
  end
end
