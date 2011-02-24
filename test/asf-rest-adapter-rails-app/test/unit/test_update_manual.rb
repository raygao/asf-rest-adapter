require 'rubygems'
require 'test_helper'

# To add log for non-rails app, see  http://rails-nutshell.labs.oreilly.com/ch08.html
class Salesforce::Rest::RestCreateDeleteTest < ActiveSupport::TestCase

  def setup
    require 'asf-soap-adapter'
    p "*" * 80
    p 'Set up code'
    @u = Salesforce::User.first
    @version = "v" + @u.connection.config[:api_version].to_s
    puts "Sf User name is: " + @u.name

    @oauth_token = @u.connection.binding.instance_variable_get("@session_id")
    puts "oauth token is: " + @oauth_token

    @soap_url = @u.connection.binding.instance_variable_get("@server").address
    @rest_svr_url = @soap_url.gsub(/-api\S*/mi, "") + ".salesforce.com"
    puts 'rest_svr_url' + @rest_svr_url

    Salesforce::Rest::AsfRest.setup(@oauth_token, @rest_svr_url, @version)
  end

  #Find a single object with REST API
  def test_update
    #Again the delete feature from ActiveResource does not work out of the box.
    #Using custom delete function
    puts "--create a new account--"
    new_acct = Salesforce::Rest::Account.new(:Name => "test numero uno", :BillingStreet=> "Fairway Meadows",
      :BillingState => "NY", :ShippingCity => "New York")
    resp = new_acct.save()

    assert (resp.code == "201")
    j = ActiveSupport::JSON
    @sf_oid = j.decode(resp.body)["id"]
    puts "New Object created: id -> "  + @sf_oid

    puts "--update that new account--"
    serialized_json = '{"BillingState":"WA"}'
    http = Net::HTTP.new(@rest_svr_url, 443)
    http.use_ssl = true
    
    class_name = "Account"
    path = "/services/data/v21.0/sobjects/#{class_name}/#{@sf_oid}"
    headers = {
      'Authorization' => "OAuth "+ @oauth_token,
      "content-Type" => 'application/json',
    }
    code = serialized_json
    
    req = Net::HTTPGenericRequest.new("PATCH", true, true, path, headers)

    resp = http.request(req, code) { |response|  }
    assert !resp.nil?

    puts resp.to_s
  end

end
