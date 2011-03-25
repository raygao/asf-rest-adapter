=begin
  ASF-REST-Adapter
  Copyright 2010 Raymond Gao @ http://are4.us

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
     http://www.apache.org/licenses/LICENSE-2.0
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
=end

module Salesforce
  module Rest

    class AsfRest < ActiveResource::Base
      module Authentication
        # Initializes the adapter, using username, password. A good place to invoke
        # it includes 'setup()' method in the 'test_helper' and Rails init files.
        # usage ->     bootup_rest_adapter(username, password, api_version)
        def self.bootup_rest_adapter(username, password, api_version)
          p "*" * 80
          p 'Set up code'

          login_svr = 'https://login.salesforce.com'
          api_version = api_version ? api_version : '21.0'

          uri = URI.parse(login_svr)
          uri.path = "/services/Soap/u/" + (api_version).to_s
          url = uri.to_s

          binding = RForce::Binding.new(url, nil, nil)
          soap_response = binding.login(username, password)
          soap_server_url = soap_response.loginResponse.result.serverUrl
          security_token = soap_response.loginResponse.result.sessionId
          user_id = soap_response.loginResponse.result.userId
          puts "binding user id is: " + user_id

          rest_svr = soap_server_url.gsub(/-api\S*/mi, "") + ".salesforce.com"
          rest_version = "v" + api_version

          self.setup(security_token, rest_svr, rest_version)
          puts "oauth token is: " + security_token

          puts 'rest_svr' + rest_svr

          return [security_token, rest_svr, rest_version]
        end


        # Initializes the adapter, the 1st step of using the adapter. A good place to invoke
        # it includes 'setup()' method in the 'test_helper' and Rails init file.
        # TODO, to be removed in the 1.0 version
        # usage ->     bootup_rest_adapter_old_adapter()
        def self.bootup_rest_adapter_with_old_adapter()
          require 'asf-soap-adapter'
          p "*" * 80
          p 'Set up code'
          @u = Salesforce::User.first
          @version = "v" + @u.connection.config[:api_version].to_s
          puts "Sf User name is: " + @u.name

          @oauth_token = @u.connection.binding.instance_variable_get("@session_id")
          puts "oauth token is: " + @oauth_token

          @soap_url = @u.connection.binding.instance_variable_get("@server").address
          @rest_svr = @soap_url.gsub(/-api\S*/mi, "") + ".salesforce.com"
          puts 'rest_svr' + @rest_svr

          self.setup(@oauth_token, @rest_svr, @version)
          return [@oauth_token, @rest_svr, @version]
        end

      end
    end
  end
end
