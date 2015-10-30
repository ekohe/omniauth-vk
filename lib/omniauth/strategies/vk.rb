require 'omniauth/strategies/oauth2'

module OmniAuth
  module Strategies
    # OAuth 2.0 authentication strategy for vk.com.
    # https://vk.com/dev/authentication
    #
    class Vk < OmniAuth::Strategies::OAuth2
      option :name, 'vk'
      option :client_options, site: 'https://api.vk.com/',
                              token_url: 'https://oauth.vk.com/access_token',
                              authorize_url: 'https://oauth.vk.com/authorize'

      option :authorize_options, [:redirect_uri, :display, :scope, :response_type, :v, :state]

      def authorize_params
        super.tap do |params|
          %i(authorize_options client_options).each do |v|
            params[v] = request.params[v] if request.params[v]
          end
          session['omniauth.state'] = params[:state] if params['state']
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
        access_token.options[:param_name] = :access_token
        @raw_info ||= begin
          params = { v: OmniAuth::Vk::API_VERSION }

          %i(lang v https test_mode fields).each do |v|
            params[v] = options[v] if options[v]
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
