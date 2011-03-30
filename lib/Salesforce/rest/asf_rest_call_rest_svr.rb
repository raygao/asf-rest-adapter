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

#CallRemote module (methods) for the adapter
puts ' loading asf_rest_call_rest_svr module'
module CallRemote
  # instance method

  #class methods
  def self.included(base)
    class << base

      def call_rest_svr (verb, target, headers, data=nil)
        case verb
        when 'GET'
          return resp = HTTParty.get(target, :headers => headers)
        when 'POST'
          return resp = HTTParty.post(target, :body => data, :headers => headers)
        when 'DELETE'
          return resp = HTTParty.delete(target, :headers => headers)
        when 'PATCH'
          # TODO use Httpgeneric.
        when 'DEFINE'
          # TODO for creating a new SObject in Salesfore, e.g. rake
        when 'REMOVE'
          # TODO for deleting a new SObject in Salesfore, e.g. rake
        when 'MODIFY'
          # TODO for modifying a new SObject in Salesfore, e.g. rake
        end
      end
    end
  end
end