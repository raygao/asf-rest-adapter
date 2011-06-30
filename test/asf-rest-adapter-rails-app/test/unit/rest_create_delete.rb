require 'rubygems'
require 'test_helper'


# To add log for non-rails app, see  http://rails-nutshell.labs.oreilly.com/ch08.html
class Salesforce::Rest::RestCreateDeleteTest < ActiveSupport::TestCase

  #Find a single object with REST API
  def test_create_rest_resources
    begin
      #Salesforce::Rest::Account.format = ActiveResource::Formats::JsonFormat

      puts "--create a new account--"
      new_acct = Salesforce::Rest::Account.new(:Name => "test numero uno", :BillingStreet=> "Fairway Meadows",
        :BillingState => "NY", :ShippingCity => "New York")
      resp = new_acct.save()

     # resp = Salesforce::Rest::Account.new("Name" => '123Test').save
    # See http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html
      # HTTP Code 201 is created successfully.
      assert (resp.code == 201)
      j = ActiveSupport::JSON
      @sf_oid = j.decode(resp.body)["id"]      
      puts "New Object created: id -> "  + @sf_oid

      puts "--delete that newly created account--"
      del_result = Salesforce::Rest::Account.delete(@sf_oid)
      assert (del_result.code == 204)
      puts "Delete Operation HTTP response code: " + del_result.code.to_s
      
    end

  end

end
