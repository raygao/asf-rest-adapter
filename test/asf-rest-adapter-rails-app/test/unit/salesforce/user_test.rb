require 'test_helper'


class Salesforce::Rest::UserTest < ActiveSupport::TestCase

    # Get detailed info about an object
  def notest_get_detail_info

    class_name_tmp = self.class.name.gsub(/\S+::/mi, "")
    class_name = class_name_tmp.gsub(/Test/mi, "")

    puts class_name
    master_get_detail_info(class_name)
  end

    #Find a single item by ID
  def test_find_a_single_item
    #rest_acct = Salesforce::Rest::Account.find("001A0000009ajW7IAI")
    puts "-- find an single object with SF OID --"
    rest_user = Salesforce::Rest::User.find("005A0000000S2C7IAK")
    assert !rest_user.empty?
    puts "#" * 80
=begin
  # No longer valid, because ActiveResource has been removed.
    rest_user.attributes.each do |user_attr|
      unless user_attr[1].nil?
        puts user_attr[0] + ":   " + user_attr[1].to_s
      else
        puts user_attr[0] + ":   "
      end
    end
=end
    rest_user.keys.each do |key|
      unless key.nil?
        pp key + ":   " + rest_user[key].to_s
      else
        pp key + ":   "
      end
    end
  end
  
end
