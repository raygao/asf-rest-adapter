require 'test_helper'

class Salesforce::MotherOfChildTest < ActiveSupport::TestCase


require Rails.root.to_s + '/app/models/salesforce/rest/Conference__c.rb'

begin
  def test_get_detail_info

    class_name_tmp = self.class.name.gsub(/\S+::/mi, "")
    class_name = class_name_tmp.gsub(/Test/mi, "")

    puts class_name
    master_get_detail_info("Conference__c")
  end

end
end
