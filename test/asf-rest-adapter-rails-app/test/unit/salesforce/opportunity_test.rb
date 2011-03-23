require 'test_helper'

class Salesforce::OpportunityTest < ActiveSupport::TestCase

    # Get detailed info about an object
  def test_get_detail_info

    class_name_tmp = self.class.name.gsub(/\S+::/mi, "")
    class_name = class_name_tmp.gsub(/Test/mi, "")

    puts class_name
    master_get_detail_info(class_name)
  end

  #SOQL query
  def test_scoreboard
    puts "## run soql ##"

    query = "SELECT id, AccountId, Amount, Probability, Owner.name, Owner.LastName, Owner.FirstName, Owner.SmallPhotoUrl, IsWon from Opportunity where isWon=true"

    puts "----- query is:   " + query
    resp = Salesforce::Rest::AsfRest.run_soql(query)

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
      # Get detailed info about an object
  
end
