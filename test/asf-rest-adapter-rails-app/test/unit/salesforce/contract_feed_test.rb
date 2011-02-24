require 'test_helper'

class Salesforce::ContractFeedTest < ActiveSupport::TestCase

    # Get detailed info about an object
  def test_get_detail_info

    class_name_tmp = self.class.name.gsub(/\S+::/mi, "")
    class_name = class_name_tmp.gsub(/Test/mi, "")

    puts class_name
    master_get_detail_info(class_name)
  end
  
end
