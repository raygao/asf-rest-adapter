require 'rubygems'
require 'test_helper'


# To add log for non-rails app, see  http://rails-nutshell.labs.oreilly.com/ch08.html
class Salesforce::Rest::RestCreateDeleteTest < ActiveSupport::TestCase

  #Find a single object with REST API
  def test_update
    #Again the delete feature from ActiveResource does not work out of the box.
    #Using custom delete function
    
    Salesforce::Rest::Account.format = ActiveResource::Formats::JsonFormat

  puts "--create a new account--"
  new_acct = Salesforce::Rest::Account.new(:Name => "test numero uno", :BillingStreet=> "Fairway Meadows",
    :BillingState => "NY", :ShippingCity => "New York")
  resp = new_acct.save()
    # See http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html
    # HTTP Code 201 is created successfully.
    assert (resp.code == 201)
    j = ActiveSupport::JSON
    @sf_oid = j.decode(resp.body)["id"]      
    puts "New Object created: id -> "  + @sf_oid    

    puts "--update that account with json--"
    serialized_json = '{"BillingState":"FL"}'
    resp = Salesforce::Rest::Account.update(@sf_oid, serialized_json)
    assert (resp.code == "204")
  end

end
