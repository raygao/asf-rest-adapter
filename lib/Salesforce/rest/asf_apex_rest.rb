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

require 'net/https'
require 'net/http'
require 'active_resource'
require 'httparty'
require 'rforce'


module Salesforce
  module Rest
    # This is the mother class of all Salesforce REST objects
    # In Force.com REST, there is no 's' at the end of SObjects
    # e.g.
    # set_collection_name "User"

    # URL Path is http://<instance>.salesforce.com/services/apexrest
    class AsfApexRest < AsfRest
      def self.setup(oauth_token, rest_svr, api_version)
        @@oauth_token = oauth_token
        @@rest_svr = rest_svr
        @@api_version = api_version ? api_version : "v21.0"  #take a dynamic api server version
        @@rest_svr_url = rest_svr + "/services/apexrest"
        @@ssl_port = 443  # TODO, right SF use port 443 for all HTTPS traffic.

        # To be used by HTTParty
        @@auth_header = {
          "Authorization" => "OAuth " + @@oauth_token,
          "content-Type" => 'application/json'
        }
        # either application/xml or application/json
        base_uri rest_svr

        return self
      end

      #Save the Object, Note: there is an inconsistency between the Salesforce REST
      #JSON create object, which is just {"Name1":"value1","Name2":"value2"}
      #where as the 'save' method of the ActiveResource produces a JSON of
      #{"Object Name":{"Name1":"value1","Name2":"value2"}}.
      #The Extra/missing 'Object Name' causes this to break.
      #When this consistency is resolved, this method should be removed.
      # header = {
      #    "Authorization" => "OAuth " + @@oauth_token,
      #    "content-Type" => 'application/json'
      #  }
      # rest_svr = 'https://na7.salesforce.com'
      # api_version = 'v21.0' with v prefix
      def save(header=Salesforce::Rest::AsfRest.send(:class_variable_get, "@@auth_header"),
          rest_svr=Salesforce::Rest::AsfRest.send(:class_variable_get, "@@rest_svr"),
          api_version=Salesforce::Rest::AsfRest.send(:class_variable_get, "@@api_version"))
        class_name = self.class.name.gsub(/\S+::/mi, "")
        path = "/services/apexrest/#{class_name}/"
        target = rest_svr + path
        data = ActiveSupport::JSON::encode(attributes)

        resp = Salesforce::Rest::AsfRest::call_rest_svr("POST", target, header, data)

        # HTTP code 201 means it was successfully saved.
        if resp.code != 201
          message = ActiveSupport::JSON.decode(resp.body)[0]["message"]
          Salesforce::Rest::ErrorManager.raise_error("HTTP code " + resp.code.to_s + ": " + message, resp.code)
        else
          return resp
        end
      end

      #Again the delete feature from ActiveResource does not work out of the box.
      #Using custom delete function
      def self.delete(id, header=Salesforce::Rest::AsfRest.send(:class_variable_get, "@@auth_header"),
          rest_svr=Salesforce::Rest::AsfRest.send(:class_variable_get, "@@rest_svr"),
          api_version=Salesforce::Rest::AsfRest.send(:class_variable_get, "@@api_version"))
        class_name = self.name.gsub(/\S+::/mi, "")
        path = "/services/apexrest/#{class_name}/#{id}"
        target = rest_svr + path
        resp = Salesforce::Rest::AsfRest::call_rest_svr("DELETE", target, header)

        # HTTP code 204 means it was successfully deleted.
        if resp.code != 204
          message = ActiveSupport::JSON.decode(resp.body)[0]["message"]
          Salesforce::Rest::ErrorManager.raise_error("HTTP code " + resp.code.to_s + ": " + message, resp.code)
        else
          return resp
        end
      end

      #Again the find feature from ActiveResource does not support multi-user access
      #Using custom Find function
      def self.find(id, header=Salesforce::Rest::AsfRest.send(:class_variable_get, "@@auth_header"),
          rest_svr=Salesforce::Rest::AsfRest.send(:class_variable_get, "@@rest_svr"),
          api_version=Salesforce::Rest::AsfRest.send(:class_variable_get, "@@api_version"))
        class_name = self.name.gsub(/\S+::/mi, "")
        path = "/services/apexrest/#{class_name}/#{id}"
        target = rest_svr + path
        resp = Salesforce::Rest::AsfRest::call_rest_svr("GET", target, header)

        # HTTP code 204 means it was successfully deleted.
        if resp.code != 200
          message = ActiveSupport::JSON.decode(resp.body)[0]["message"]
          Salesforce::Rest::ErrorManager.raise_error("HTTP code " + resp.code.to_s + ": " + message, resp.code)
        else
          return resp
        end
      end


      #Update an object # TODO to use the call_rest_svr method
      def self.update(id, serialized_data_json, header=Salesforce::Rest::AsfRest.send(:class_variable_get, "@@auth_header"),
          rest_svr=Salesforce::Rest::AsfRest.send(:class_variable_get, "@@rest_svr"),
          api_version=Salesforce::Rest::AsfRest.send(:class_variable_get, "@@api_version"))

        #Again the delete feature from ActiveResource does not work out of the box.
        #Providing a custom update function
        svr_url_4_http = rest_svr.gsub(/https:\/\//mi, "" )  #strip http:// prefix from the url. Otherwise, it will fail.
        if @@ssl_port.nil?
          @@ssl_port = 443
        end
        http = Net::HTTP.new(svr_url_4_http, @@ssl_port)
        http.use_ssl = true
        class_name = self.name.gsub(/\S+::/mi, "")
        path = "/services/apexrest/#{class_name}/#{id}"
        code = serialized_data_json
        #   format -> Net::HTTPGenericRequest.new(m, reqbody, resbody, path, initheader)
        req = Net::HTTPGenericRequest.new("PATCH", true, true, path, header)
        resp = http.request(req, code) { |response|  }

        # HTTP code 204 means it was successfully updated. 204 for httparty, '204' for Net::HTTP
        if resp.code != '204'
          message = ActiveSupport::JSON.decode(resp.body)[0]["message"]
          Salesforce::Rest::ErrorManager.raise_error("HTTP code " + resp.code.to_s + ": " + message, resp.code)
        else
          return resp
        end
      end

    end
  end
end
