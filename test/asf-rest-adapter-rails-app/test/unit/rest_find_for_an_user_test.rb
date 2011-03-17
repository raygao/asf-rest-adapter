require 'test_helper'
# see test_helper
#require 'lib/asf-rest-adapter.rb'
#require 'asf-soap-adapter'

class Salesforce::Rest::RestFindForAnUserTest < ActiveSupport::TestCase

  #SOSL search
  def test_run_sosl_for_an_user
    username = 'username'
    password = 'password + security token'
    login_svr = 'https://login.salesforce.com'
    api_version = '21.0'

    query = "Select id, name from User"
    
    puts "## run sosl ##"
    search = "FIND+{test}"
    resp = Salesforce::Rest::AsfRest.run_sosl_for_an_user(search, username, password)

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
  def test_run_soql_for_an_user
    username = 'username'
    password = 'password + security token'
    login_svr = 'https://login.salesforce.com'
    api_version = '21.0'

    query = "Select id, name from User"

        puts "## run soql ##"
    resp = Salesforce::Rest::AsfRest.run_soql_for_an_user(query, username, password)

    counter = 0
    puts '-> Total found rows ' + resp['totalSize'].to_s
    while counter < resp['totalSize']
      puts '-' * 36 + " row: #{counter} " + '-' * 36
      pp resp['records'][counter]
      puts '-' * 80
      counter = counter + 1
    end
    assert !resp.nil?
  end

end
