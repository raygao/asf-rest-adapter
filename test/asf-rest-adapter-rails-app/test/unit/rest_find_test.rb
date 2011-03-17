require 'test_helper'
# see test_helper
#require 'lib/asf-rest-adapter.rb'
#require 'asf-soap-adapter'

class Salesforce::Rest::RestFindTest < ActiveSupport::TestCase
  # This will break due to an ActiveResource bug.
=begin
  def notest_find_all_will_break
    #account_rest = Salesforce::Rest::AccountRest.setup(oauth_token, rest_svr_url).find("001A0000009ajW7IAI")
    puts "## find all ##"
    accounts_rest = Salesforce::Rest::Account.find(:all)
  end
=end
  #Find a single item by ID
  def test_find_a_single_item
    #rest_acct = Salesforce::Rest::Account.find("001A0000009ajW7IAI")
    puts "## find an single object with SF OID ##"
    rest_user = Salesforce::Rest::User.xfind("005A0000000FKy4IAG")
    assert !rest_user.empty?
    puts "#" * 80

    rest_user.attributes.each do |user_attr|
      unless user_attr[1].nil?
        pp user_attr[0] + ":   " + user_attr[1].to_s
      else
        pp user_attr[0] + ":   "
      end
    end
  end

  #SOSL search
  def test_run_sosl
    puts "## run sosl ##"
    search = "FIND+{test}"
    resp = Salesforce::Rest::AsfRest.xrun_sosl(search)

    counter = 0
    while counter < resp.size
      puts '-' * 36 + " row: #{counter} " + '-' * 36
      pp resp[counter]
      puts '-' * 80
      counter = counter + 1
    end
    assert !resp.nil?
  end


  #SOQL query
  def test_run_soql
    puts "## run soql ##"
    #query = "SELECT+Name,+id,+BillingCity+from+Account"
    query = "SELECT Name, id, BillingCity from Account"

    resp = Salesforce::Rest::AsfRest.xrun_soql(query)

    counter = 0
    while counter < resp['totalSize']
      puts '-' * 36 + " row: #{counter} " + '-' * 36
      pp resp['records'][counter]
      puts '-' * 80
      counter = counter + 1
    end
    assert !resp.nil?
  end


  #Describe Global
  def test_describe_global
    puts "## describe global ##"
    resp = Salesforce::Rest::AsfRest.xdescribe_global()

    pp resp
    #puts "***now:*** data =>   " + resp.body
    assert !resp.nil?
  end


  # Get detailed info about an object
  def test_get_detail_info
    puts "## get detail info about an object##"
    resp = Salesforce::Rest::Account.xget_detail_info()

    resp.each {|key, val| pp key + ' => ' + val.to_s}
    #puts "***now:*** data =>   " + resp.body
    assert !resp.nil?
  end

  # Get Meta data about a salesforce object model
  def test_get_meta_data
    puts "## get meta data about an object model##"
    resp = Salesforce::Rest::Account.xget_meta_data()

    pp resp
    assert !resp.nil?
  end

  # Get Resources available on this REST server
  def test_list_available_resources
    puts "## list_available_resources (retrieveable SF objects) ##"
    resp = Salesforce::Rest::AsfRest.xlist_available_resources()

    resp.each {|key, val| pp key + ' => ' + val.to_s}
    assert !resp.nil?
  end


  # Get the version of the REST Server
  def test_get_versions
    puts "## get api server version ##"
    resp = Salesforce::Rest::AsfRest.xget_version()

    counter = 0
    resp.each do |row|
      puts '-' * 36 + " row: #{counter} " + '-' * 36
      row.keys.each do  |key|
        pp key + " => "  + row[key]
      end
      puts '-' * 80
      counter = counter + 1
    end
    assert !resp.nil?
  end

end
