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
    # all subclasses need to set the collection name. In ActiveResource convention,
    # pluralized elements has the ending 's'; whereas, in Force.com REST, that 's'
    # is not there.
    # e.g.
    # set_collection_name "User"
    #
    # TODO cannot do "SObject.find(:all)" due to a defect in the ActiveResource framework,
    # see -> ActiveResource::Base line # 885
    #  def instantiate_collection(collection, prefix_options = {})
    #        collection.collect! { |record| instantiate_record(record, prefix_options) }
    #  end
    # As Ruby Hash has not collect! method, only Array,
    # We we get back from Salesforce is a hash
    # <sobject><objectDescribe><.....></objectDescribe><recentItems>...</recentItems></sobject>
    class AsfRest < ActiveResource::Base
      include HTTParty

      # default REST API server for HTTParty
      base_uri "https://na7.salesforce.com"
      default_params :output => 'json'
      format :json
      @@ssl_port = 443  

      #ActiveResource setting
      self.site = "https://na7.salesforce.com/services/data/v21.0/sobjects"

      # set header for httparty
      def self.set_headers (auth_setting)
        headers (auth_setting)
      end

      # Loading the Authenticate module
      require File.dirname(__FILE__) + '/asf_rest_authenticate.rb'
      include Authenticate

      # Loading the Call Remote module
      require File.dirname(__FILE__) + '/asf_rest_call_rest_svr.rb'
      include CallRemote

      # Loading the OrgModel module
      require File.dirname(__FILE__) + '/asf_rest_org_model.rb'
      include OrgModel

      # Loading the CachedCalls module
      require File.dirname(__FILE__) + '/asf_rest_cached_calls.rb'
      include CachedCalls

      # We are mocking OAuth type authentication. In our case, we use the
      # SessionID obtained from the initial SOAP Web Services call - 'login()'
      # OAuth2 is geared toward website to website authentication.
      # In our case, we are the background data interchange between RoR app and
      # Force.com database. Therefore, we use security id.
      # example:
      # connection.set_header("Authorization",  'OAuth 00DA0000000XwIQ!AQIAQD_BX.pdxMz0YBKdkz45PijY0gMxH65JwvV6Yj4.hf44WJYqO9ug7DfhNbnxuO9buhbftiX9Qv5DyBLHauaJhqTh79vi')
      #
      # self.abstract_class = true
      #
      # Setup the adapter
      def self.setup(oauth_token, rest_svr, api_version)
        @@oauth_token = oauth_token
        @@rest_svr = rest_svr
        @@api_version = api_version ? api_version : "v21.0"  #take a dynamic api server version
        @@rest_svr_url = rest_svr + "/services/data/#{api_version}/sobjects"
        @@ssl_port = 443  # TODO, right SF use port 443 for all HTTPS traffic.

        #ActiveResource setting
        #self.site = "https://" +  @@rest_svr_url
        self.site = @@rest_svr_url
        connection.set_header("Authorization", "OAuth " + @@oauth_token)

        # To be used by HTTParty
        @@auth_header = {
          "Authorization" => "OAuth " + @@oauth_token,
          "content-Type" => 'application/json'
        }
        # either application/xml or application/json
        base_uri rest_svr
        self.format = :json

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
        path = "/services/data/#{api_version}/sobjects/#{class_name}/"
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
        path = "/services/data/#{api_version}/sobjects/#{class_name}/#{id}"
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
        path = "/services/data/#{api_version}/sobjects/#{class_name}/#{id}"
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


      #Custom object with PATCH method
      class TrackRequest < Net::HTTPRequest
        METHOD = 'PATCH'
        REQUEST_HAS_BODY = true
        RESPONSE_HAS_BODY = true
      end

      #Update an object # TODO to use the call_rest_svr method
      def self.update(id, serialized_data_json, header=Salesforce::Rest::AsfRest.send(:class_variable_get, "@@auth_header"),
          rest_svr=Salesforce::Rest::AsfRest.send(:class_variable_get, "@@rest_svr"),
          api_version=Salesforce::Rest::AsfRest.send(:class_variable_get, "@@api_version"))

        #Again the delete feature from ActiveResource does not work out of the box.
        #Providing a custom update function
        svr_url_4_http = rest_svr.gsub(/https:\/\//mi, "" )  #strip http:// prefix from the url. Otherwise, it will fail.
        http = Net::HTTP.new(svr_url_4_http, @@ssl_port)
        http.use_ssl = true
        class_name = self.name.gsub(/\S+::/mi, "")
        path = "/services/data/#{api_version}/sobjects/#{class_name}/#{id}"
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

      # Run SOQL, automatically CGI::escape the query for you.
      def self.run_soql(query, header=Salesforce::Rest::AsfRest.send(:class_variable_get, "@@auth_header"),
          rest_svr=Salesforce::Rest::AsfRest.send(:class_variable_get, "@@rest_svr"),
          api_version=Salesforce::Rest::AsfRest.send(:class_variable_get, "@@api_version"))
        class_name = self.name.gsub(/\S+::/mi, "")
        safe_query = CGI::escape(query)
        path = "/services/data/#{api_version}/query?q=#{safe_query}"
        target = rest_svr+path
        resp = Salesforce::Rest::AsfRest::call_rest_svr("GET", target, header)
        #resp = get(path, options)
        if (resp.code != 200) || !resp.success?
          message = ActiveSupport::JSON.decode(resp.body)[0]["message"]
          Salesforce::Rest::ErrorManager.raise_error("HTTP code " + resp.code.to_s + ": " + message, resp.code)
        end
        return resp
      end

      # Run SOQL, automatically CGI::escape the query for you.
      # This is with given credentials -> query, security_token, rest_svr, version
      # the path with appropriate api_version, CGI escaping the query string is
      # included in this method.
      def self.run_soql_with_credential(query, security_token, rest_svr, api_version)
        header = { "Authorization" => "OAuth " + security_token, "content-Type" => 'application/json' }
        #set the path with appropriate api_version, include CGI escaping the query string
        safe_query = CGI::escape(query)
        path = "/services/data/#{api_version}/query?q=#{safe_query}"
        target = rest_svr + path
        #get the result
        resp = Salesforce::Rest::AsfRest::call_rest_svr("GET", target, header)
        if (resp.code != 200) || !resp.success?
          message = ActiveSupport::JSON.decode(resp.body)[0]["message"]
          Salesforce::Rest::ErrorManager.raise_error("HTTP code " + resp.code.to_s + ": " + message, resp.code)
        end
        return resp
      end


      # Run SOSL, do not use CGI::escape -> SF will complain about missing {braces}
      def self.run_sosl(search, header=Salesforce::Rest::AsfRest.send(:class_variable_get, "@@auth_header"),
          rest_svr=Salesforce::Rest::AsfRest.send(:class_variable_get, "@@rest_svr"),
          api_version=Salesforce::Rest::AsfRest.send(:class_variable_get, "@@api_version"))
        options = { :query => {:q => search}}
        class_name = self.name.gsub(/\S+::/mi, "")
        path = URI.escape("/services/data/#{api_version}/search/?q=#{search}")
        target = rest_svr + path
        resp = Salesforce::Rest::AsfRest::call_rest_svr("GET", target, header)
        if (resp.code != 200) || !resp.success?
          message = ActiveSupport::JSON.decode(resp.body)[0]["message"]
          Salesforce::Rest::ErrorManager.raise_error("HTTP code " + resp.code.to_s + ": " + message, resp.code)
        end
        return resp
      end

      # Run SOSL, do not use CGI::escape -> SF will complain about missing {braces}
      # This is with given credentials -> Search_query, security_token, rest_svr, version
      def self.run_sosl_with_credential(search, security_token, rest_svr, api_version)
        header = { "Authorization" => "OAuth " + security_token, "content-Type" => 'application/json' }
        #set the path with appropriate api_version, with the search string
        path = URI.escape("/services/data/#{api_version}/search/?q=#{search}")
        target = rest_svr + path
        #get the result
        resp = Salesforce::Rest::AsfRest::call_rest_svr("GET", target, header)
        if (resp.code != 200) || !resp.success?
          message = ActiveSupport::JSON.decode(resp.body)[0]["message"]
          Salesforce::Rest::ErrorManager.raise_error("HTTP code " + resp.code.to_s + ": " + message, resp.code)
        end
        return resp
      end

      # Used for removing the .xml and .json extensions at the end of the URL link.
      class << self
        # removing http://....../UID.xml
        def element_path(id, prefix_options = {}, query_options = nil)
          prefix_options, query_options = split_options(prefix_options) if query_options.nil?
          "#{prefix(prefix_options)}#{collection_name}/#{id}#{query_string(query_options)}"
        end
        # removing http://....../UID.json
        def collection_path(prefix_options = {}, query_options = nil)
          prefix_options, query_options = split_options(prefix_options) if query_options.nil?
          "#{prefix(prefix_options)}#{collection_name}#{query_string(query_options)}"
        end
      end
    end
  end
end
