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

    class AsfRestError < RuntimeError
      attr :fault

      def initialize(message, fault = nil)
        super message
        @fault = fault
      end
    end

    # Manages error and raise appropriate runtime errors.
    class ErrorManager
      def self.raise_error (message, http_code)
        case http_code
        when 400
          raise Salesforce::Rest::AsfRequestError.new(message, http_code)
        when 401
          raise Salesforce::Rest::AsfAuthenticationError.new(message, http_code)
        when 403
          raise Salesforce::Rest::AsfRequestError.new(message, http_code)
        when 404
          raise Salesforce::Rest::AsfResourceNotFoundError.new(message, http_code)
        when 405
          raise Salesforce::Rest::AsfMethodError.new(message, http_code)
        when 415
          raise Salesforce::Rest::AsfEntityError.new(message, http_code)
        when 500
          raise Salesforce::Rest::AsfPlatformrror.new(message, http_code)
        else
          raise Salesforce::Rest::AsfRuntimeError.new(message, http_code)
        end
      end
    end

    # Unspecified error.
    class AsfRuntimeError < AsfRestError
      def initialize(message, http_code)
        super(message, http_code)
      end
    end

    # Error for HTTP code 401, Session ID or Auth token expired
    class AsfAuthenticationError < AsfRestError
      def initialize(message, http_code)
        super(message, http_code)
      end
    end

    # Error for HTTP code 400, Request cannot be understood, because the JSON
    # or XML body has an error
    class AsfRequestError < AsfRestError
      def initialize(message, http_code)
        super(message, http_code)
      end
    end

    # Error for HTTP code 403, Request cannot be understood, because the JSON
    # or XML body has an error
    class AsfRequestRefusedError < AsfRestError
      def initialize(message, http_code)
        super(message, http_code)
      end
    end

    # Error for HTTP code 404, Requested resource cannot be found. Check URI for error.
    class AsfResourceNotFoundError < AsfRestError
      def initialize(message, http_code)
        super(message, http_code)
      end
    end

    # Error for HTTP code 405, The method specified in the Request-Line is not allowed.
    class AsfMethodError < AsfRestError
      def initialize(message, http_code)
        super(message, http_code)
      end
    end

    # Error for HTTP code 415. The entity specified in the request is in a format
    # that is supported by the specified resource for the specified method.
    class AsfEntityError < AsfRestError
      def initialize(message, http_code)
        super(message, http_code)
      end
    end

    # Error for HTTP code 500, Force.com Internal Server error
    class AsfPlatformrror < AsfRestError
      def initialize(message, http_code)
        super(message, http_code)
      end
    end

  end
end