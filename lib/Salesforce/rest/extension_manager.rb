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

# Used for removing the .xml and .json extensions at the end of the URL link.

module Salesforce
  module Rest
    class AsfRest < ActiveResource::Base
      module ExtensionManager
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
end
