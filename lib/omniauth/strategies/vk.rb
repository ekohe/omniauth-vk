require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    # OAuth 2.0 authentication strategy for vk.com.
    # https://vk.com/dev/authentication
    #
    class Vk < OmniAuth::Strategies::OAuth2
      option :client_options, site: 'https://api.vk.com/',
                              token_url: 'https://oauth.vk.com/access_token',
                              authorize_url: 'https://oauth.vk.com/authorize'

      option :authorize_options, [:redirect_uri, :display, :scope, :response_type, :v, :state]

      def authorize_params
        super.tap do |params|
          %w(authorize_options client_options).each do |v|
            request.params[v] && params[v.to_sym] = request.params[v]
          end
          params['state'] && session['omniauth.state'] = params[:state]
        end
      end

      uid { raw_info['id'] }

      info do
        {
          name: [raw_info['first_name'], raw_info['last_name']].join(' '),
          first_name: raw_info['first_name'],
          last_name: raw_info['last_name']
        }.merge access_token.params
      end

      extra do
        { raw_info: raw_info }
      end

      def raw_info
        access_token.options[:mode] = :query
        @raw_info ||= begin
          params = { v: OmniAuth::Vk::API_VERSION }

          %i(lang v https test_mode fields).each do |v|
            options[v] && params[v] = options[v]
          end

          access_token.get('/method/users.get', params: params).parsed['response'].first
        end
      end

      private

      def callback_url
        options[:redirect_uri] || (full_host + script_name + callback_path)
      end
    end
  end
end

OmniAuth.config.add_camelization 'vk', 'Vk'
