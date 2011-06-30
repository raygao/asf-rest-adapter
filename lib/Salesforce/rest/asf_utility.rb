module Salesforce
  module Rest
    # This provides various utilities for the framework, one of which is extracting
    # refresh, security tokens, and CS key + secret
    class AsfUtility
      # Takes Request Object and
      # Returns Hash of:
      #  authhash[:token_security] = omniauth['credentials']['token']
      #  authhash[:token_refresh] = omniauth['credentials']['refresh_token']
      #  authhash[:sf_consumer_key] = omniauth['credentials']['consumer_key']
      #  authhash[:sf_consumer_secret] = omniauth['credentials']['consumer_secret']
      def self.get_tokens(request)
        authhash = Hash.new

        omniauth = request.env['omniauth.auth']
        
        authhash[:token_security] = omniauth['credentials']['token']
        authhash[:token_refresh] = omniauth['credentials']['refresh_token']
        authhash[:sf_consumer_key] = omniauth['credentials']['consumer_key']
        authhash[:sf_consumer_secret] = omniauth['credentials']['consumer_secret']

        #return [security_token, refresh_token, consumer_key, consumer_secret]

        return authhash
      end

    end
  end
end