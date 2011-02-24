require 'test_helper'

class Salesforce::MotherOfChildTest < ActiveSupport::TestCase


require RAILS_ROOT + '/app/models/salesforce/rest/mother_of_child__c.rb'

begin
  def test_get_detail_info

    class_name_tmp = self.class.name.gsub(/\S+::/mi, "")
    class_name = class_name_tmp.gsub(/Test/mi, "")

    puts class_name
    master_get_detail_info("Mother_Of_Child__c")
  end

end
end
