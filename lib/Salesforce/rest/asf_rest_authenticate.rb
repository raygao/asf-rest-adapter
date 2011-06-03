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

#Authentication module (methods) for the adapter
puts ' loading asf_rest_authenticate module'
module Authenticate
  # instance method
  
  #class methods
  def self.included(base)
    class << base
      # Initializes the adapter, using username, password. A good place to invoke
      # it includes 'setup()' method in the 'test_helper' and Rails init files.
      # usage ->     bootup_rest_adapter(username, password, api_version)
      def bootup_rest_adapter(username, password, api_version)
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

        puts 'rest_svr: ' + rest_svr

        return [security_token, rest_svr, rest_version]
      end

      # Ignite the adapter, using the config_file, This will in term invoke
      # bootup_rest_adapter(username, password, api_version) or set up with
      # consumer key/secret with omniauth
      def ignite_adapter(config_file)
        #Read the configuration file

        begin
          asf_rest_config = YAML::load(File.open(config_file))

          auth_scheme =  asf_rest_config["asf-rest-config"] ["auth_scheme"]
          puts "ASF-REST-Adapter setting:"
          puts "Auth name:" + auth_scheme

          #setup the default adapter with relevant auth schema (username/password) or (Omniauth)
          case auth_scheme
          when "username_password" then
              puts 'Setting up adapter using username/password'
            username = asf_rest_config["asf-rest-config"]["username"]
            password = asf_rest_config["asf-rest-config"]["password"]
            login_svr = asf_rest_config["asf-rest-config"]["url"].to_s
            api_version = asf_rest_config["asf-rest-config"]["api_version"].to_s

            puts "Salesforce url: " + asf_rest_config["asf-rest-config"]["url"].to_s
            puts "Username: " + username
            puts "Password: " + password
            puts "API Version " + login_svr

            security_token, rest_svr, rest_version = Salesforce::Rest::AsfRest.bootup_rest_adapter(username, password, api_version)
            puts 'Security Token: ' + security_token
            puts 'rest_svr: ' + rest_svr
            puts 'rest_version: ' + rest_version
          when"omni_auth" then
              consumer_key = asf_rest_config["asf-rest-config"]["consumer_key"]
            consumer_secret = asf_rest_config["asf-rest-config"]["consumer_secret"]

            puts "Salesforce consumer_key is:" + consumer_key.to_s
            puts "Salesforce consumser_secret is: " + consumer_secret.to_s

            Rails.application.config.middleware.use OmniAuth::Builder do
              provider :forcedotcom, consumer_key, consumer_secret
            end
          end
        rescue Exception => e
          puts e.message
        end
      end


    end
  end

end