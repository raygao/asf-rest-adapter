require 'test_helper'

class Salesforce::TaskTest < ActiveSupport::TestCase
  def setup
    p "*" * 80
    p 'Set up code'
    @u = Salesforce::User.first
    puts "Sf User name is: " + @u.name

    @oauth_token = @u.connection.binding.instance_variable_get("@session_id")
    puts "oauth token is: " + @oauth_token
    @rest_svr_url = "https://na7.salesforce.com"
    Salesforce::Rest::AsfRest.setup(@oauth_token, @rest_svr_url, "v21.0")
  end


    # Get detailed info about an object
  def test_get_detail_info

    class_name_tmp = self.class.name.gsub(/\S+::/mi, "")
    class_name = class_name_tmp.gsub(/Test/mi, "")

    puts class_name
    master_get_detail_info(class_name)
  end

end
