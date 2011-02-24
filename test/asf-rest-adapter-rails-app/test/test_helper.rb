ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

#loading ASF-REST-Adapter and ASF-SOAP-Adapter
require 'asf-rest-adapter'
#require 'lib/asf-rest-adapter.rb'
require 'asf-soap-adapter'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all


  def setup
#    initalize_adapter()
    Salesforce::Rest::AsfRest.bootup_rest_adapter()
  end

  # Add more helper methods to be used by all tests here...
end


# Get detailed info about an object
def master_get_detail_info(class_name)
  puts "-- get detail info about an object--"

  test_class = ("Salesforce::Rest::#{class_name}").constantize
  resp = test_class.xget_detail_info()

  pp resp
  #resp.each {|key, val| puts key + ' => ' + val.to_s}
  #puts "***now:*** data =>   " + resp.body

end

