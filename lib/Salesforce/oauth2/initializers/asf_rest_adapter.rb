#require 'forcedotcom' # no longer needed, it is a part of the asf-rest-adapter
require 'asf-rest-adapter'

# Set the default hostname for omniauth to send callbacks to.
# seems to be a bug in omniauth that it drops the httpS
# this still exists in 0.2.0
OmniAuth.config.full_host = 'https://localhost:3000'

module OmniAuth
  module Strategies
    #tell omniauth to load our strategy
    autoload :Forcedotcom, 'lib/forcedotcom'
  end
end


#Read the config
asf_rest_config_file = Rails.root.to_s + "/config/asf_rest_config.yml"
ASF_REST_CONFIG = YAML::load(File.open(asf_rest_config_file))

auth_scheme =  ASF_REST_CONFIG["asf-rest-config"] ["auth_scheme"]
puts "ASF-REST-Adapter setting:"
puts "Auth name:" + auth_scheme

#setup the default adapter with relevant auth schema (username/password) or (Omniauth)
case auth_scheme
when "username_password":
    puts 'Setting up adapter using username/password'
    username = ASF_REST_CONFIG["asf-rest-config"]["username"]
    password = ASF_REST_CONFIG["asf-rest-config"]["password"]
    login_svr = ASF_REST_CONFIG["asf-rest-config"]["api_version"].to_s
    api_version = ASF_REST_CONFIG["asf-rest-config"]["api_version"].to_s

    puts "Salesforce url: " + ASF_REST_CONFIG["asf-rest-config"]["url"]
    puts "Username: " + username
    puts "Password: " + password
    puts "API Version " + login_svr

    security_token, rest_svr, rest_version = Salesforce::Rest::AsfRest.bootup_rest_adapter(username, password, api_version)
    puts 'Security Token: ' + security_token
    puts 'rest_svr: ' + rest_svr
    puts 'rest_version: ' + rest_version
when"omni_auth":
    consumer_key = ASF_REST_CONFIG["asf-rest-config"]["consumer_key"]
    consumer_secret = ASF_REST_CONFIG["asf-rest-config"]["consumer_secret"]

    puts "Salesforce consumer_key is:" + consumer_key.to_s
    puts "Salesforce consumser_secret is: " + consumer_secret.to_s

    Rails.application.config.middleware.use OmniAuth::Builder do
      provider :forcedotcom, consumer_key, consumer_secret
    end
end



OT2::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.

  #add our oauth redirect route - qw
  match '/auth/:provider/callbackzzz', :to => 'sessions#create'
  match '/auth/failurezzz', :to => 'sessions#fail'

end