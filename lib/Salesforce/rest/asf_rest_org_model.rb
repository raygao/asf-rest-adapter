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

#Schema module for the adapter, dealing with meta-data and schema of the organization
puts ' loading asf_rest_org_model module'
module OrgModel
  # instance method

  #class methods
  def self.included(base)
    class << base
      # Get all available SObjects & their meta-data for an organization
      def self.describe_global(header=@@auth_header, rest_svr=@@rest_svr, api_version=@@api_version)
        path = "/services/data/#{api_version}/sobjects/"
        target = rest_svr + path
        resp = call_rest_svr("GET", target, header, nil)
        #resp = get(path)
        if (resp.code != 200) || !resp.success?
          message = ActiveSupport::JSON.decode(resp.body)[0]["message"]
          Salesforce::Rest::ErrorManager.raise_error("HTTP code " + resp.code.to_s + ": " + message, resp.code.to_s)
        end
        return resp
      end

      # get available versions for making REST API calls
      def self.get_version(header=@@auth_header, rest_svr=@@rest_svr, api_version=@@api_version)
        path = '/services/data/'
        target = rest_svr + path
        resp = call_rest_svr("GET", target, header, nil)
        if (resp.code != 200) || !resp.success?
          message = ActiveSupport::JSON.decode(resp.body)[0]["message"]
          Salesforce::Rest::ErrorManager.raise_error("HTTP code " + resp.code.to_s + ": " + message, resp.code.to_s)
        end
        return resp
      end

      # get resources available for REST, e.g. Query, Search, SObjects, Recent
      def self.list_available_resources(header=@@auth_header, rest_svr=@@rest_svr, api_version=@@api_version)       
        path = "/services/data/#{api_version}/"
        target = rest_svr + path
        resp = call_rest_svr("GET", target, header, nil)
        if (resp.code != 200) || !resp.success?
          message = ActiveSupport::JSON.decode(resp.body)[0]["message"]
          Salesforce::Rest::ErrorManager.raise_error("HTTP code " + resp.code.to_s + ": " + message, resp.code.to_s)
        end
        return resp
      end

      #Get detailed info about a single Salesforce SObject, e.g. Name, fields, edit template, etc.
      def self.get_detail_info(header=@@auth_header, rest_svr=@@rest_svr, api_version=@@api_version)
        class_name = self.name.gsub(/\S+::/mi, "")
        path = "/services/data/#{api_version}/sobjects/#{class_name}/describe"
        target = rest_svr + path        
        resp = call_rest_svr("GET", target, header, nil)
        if (resp.code != 200) || !resp.success?
          message = ActiveSupport::JSON.decode(resp.body)[0]["message"]
          Salesforce::Rest::ErrorManager.raise_error("HTTP code " + resp.code.to_s + ": " + message, resp.code.to_s)
        end
        if (resp.code != 200) || !resp.success?
          message = ActiveSupport::JSON.decode(resp.body)[0]["message"]
          Salesforce::Rest::ErrorManager.raise_error("HTTP code " + resp.code.to_s + ": " + message, resp.code.to_s)
        end
        return resp
      end

      #get meta data about an SObject, including rows of recent items
      def self.get_meta_data(header=@@auth_header, rest_svr=@@rest_svr, api_version=@@api_version)
        class_name = self.name.gsub(/\S+::/mi, "")
        path = "/services/data/#{api_version}/sobjects/#{class_name}/"
        target = rest_svr + path
        resp = call_rest_svr("GET", target, header, nil)
        if (resp.code != 200) || !resp.success?
          message = ActiveSupport::JSON.decode(resp.body)[0]["message"]
          Salesforce::Rest::ErrorManager.raise_error("HTTP code " + resp.code.to_s + ": " + message, resp.code.to_s)
        end
        return resp
      end

    end
  end
  
end
