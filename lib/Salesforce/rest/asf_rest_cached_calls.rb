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

#Cached Call module (MemCached methods) for the adapter
puts ' loading asf_rest_cached_calls module'
module CachedCalls
  # instance method

  #class methods
  def self.included(base)
    class << base

      # xfind is the cached version of the ActiveReources Find method. You will
      # see the speed improvement with memcache turned on.
      def xfind(*arguments)
        if Rails.cache.exist? arguments
          binobj = Rails.cache.read(arguments)
          # deserialize from Json
          obj = self.name.constantize.new.from_json(binobj)
          return obj
        else
          obj = self.find(arguments)
          # Save a Json, Marshal.dump or :raw does not work
          Rails.cache.write(arguments, obj.to_json())
          return obj
        end
      end

      # Memcached version of the describe_global() method
      def xdescribe_global()
        @@memcache_id =  self.name + "/describe_global"
        if Rails.cache.exist? @@memcache_id
          binobj = Rails.cache.read(@@memcache_id)
          # deserialize from Json
          obj = HTTParty::Parser.call(binobj, :json)
          return obj
        else
          obj = self.describe_global()
          # Save a Json, Marshal.dump or :raw does not work
          Rails.cache.write(@@memcache_id, obj.body)
          return obj
        end
      end

      # Memcached version of the get_detail_info() method
      def xget_detail_info()
        @@memcache_id =  self.name + "/describe"
        if Rails.cache.exist? @@memcache_id
          binobj = Rails.cache.read(@@memcache_id)
          # deserialize from Json
          obj = HTTParty::Parser.call(binobj, :json)
          return obj
        else
          obj = self.get_detail_info()
          # Save a Json, Marshal.dump or :raw does not work
          Rails.cache.write(@@memcache_id, obj.body)
          return obj
        end
      end

      # Memcached version of the get_meta_data() method
      def xget_meta_data()
        @@memcache_id =  self.name + "/meta_data"
        if Rails.cache.exist? @@memcache_id
          binobj = Rails.cache.read(@@memcache_id)
          # deserialize from Json
          obj = HTTParty::Parser.call(binobj, :json)
          return obj
        else
          obj = self.get_meta_data()
          # Save a Json, Marshal.dump or :raw does not work
          Rails.cache.write(@@memcache_id, obj.body)
          return obj
        end
      end

      # Memcached version of the list_available_resources() method
      def xlist_available_resources()
        @@memcache_id =  self.name + "/list_resources"
        if Rails.cache.exist? @@memcache_id
          binobj = Rails.cache.read(@@memcache_id)
          # deserialize from Json
          obj = HTTParty::Parser.call(binobj, :json)
          return obj
        else
          obj = self.list_available_resources()
          # Save a Json, Marshal.dump or :raw does not work
          Rails.cache.write(@@memcache_id, obj.body)
          return obj
        end
      end

      # Memcached version of the get_version() method
      def xget_version()
        @@memcache_id =  self.name + "/get_version"
        if Rails.cache.exist? @@memcache_id
          binobj = Rails.cache.read(@@memcache_id)
          # deserialize from Json
          obj = HTTParty::Parser.call(binobj, :json)
          return obj
        else
          obj = self.get_version()
          # Save a Json, Marshal.dump or :raw does not work
          Rails.cache.write(@@memcache_id, obj.body)
          return obj
        end
      end

      # Memcached version of the run_soql() method
      def xrun_soql(query)
        @@memcache_id =  self.name + "/run_soql"
        if Rails.cache.exist? @@memcache_id
          binobj = Rails.cache.read(@@memcache_id)
          # deserialize from Json
          obj = HTTParty::Parser.call(binobj, :json)
          return obj
        else
          obj = self.run_soql(query)
          # Save a Json, Marshal.dump or :raw does not work
          Rails.cache.write(@@memcache_id, obj.body)
          return obj
        end
      end

      # Memcached version of the run_sosl() method
      def xrun_sosl(search)
        @@memcache_id =  self.name + "/run_sosl"
        if Rails.cache.exist? @@memcache_id
          binobj = Rails.cache.read(@@memcache_id)
          # deserialize from Json
          obj = HTTParty::Parser.call(binobj, :json)
          return obj
        else
          obj = self.run_sosl(search)
          # Save a Json, Marshal.dump or :raw does not work
          Rails.cache.write(@@memcache_id, obj.body)
          return obj
        end
      end
      
    end
  end

end