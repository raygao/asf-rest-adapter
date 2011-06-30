=begin
  ASF-REST-Adapter
  Copyright 2010 Raymond Gao @ http://are4.us

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
=end
require File.dirname(__FILE__) + '/Salesforce/rest/asf_rest_error.rb'
require File.dirname(__FILE__) + '/Salesforce/rest/asf_connection.rb'
require File.dirname(__FILE__) + '/Salesforce/rest/asf_rest.rb'
require File.dirname(__FILE__) + '/Salesforce/rest/asf_apex_rest.rb'

#Now common objects
require File.dirname(__FILE__) + '/Salesforce/rest/classes/apex_log.rb'
require File.dirname(__FILE__) + '/Salesforce/rest/classes/account.rb'
require File.dirname(__FILE__) + '/Salesforce/rest/classes/account_feed.rb'
require File.dirname(__FILE__) + '/Salesforce/rest/classes/asset.rb'
require File.dirname(__FILE__) + '/Salesforce/rest/classes/asset_feed.rb'
require File.dirname(__FILE__) + '/Salesforce/rest/classes/campaign.rb'
require File.dirname(__FILE__) + '/Salesforce/rest/classes/campaign_feed.rb'
require File.dirname(__FILE__) + '/Salesforce/rest/classes/case.rb'
require File.dirname(__FILE__) + '/Salesforce/rest/classes/case_feed.rb'
require File.dirname(__FILE__) + '/Salesforce/rest/classes/case_team_member.rb'
require File.dirname(__FILE__) + '/Salesforce/rest/classes/contact.rb'
require File.dirname(__FILE__) + '/Salesforce/rest/classes/contact_feed.rb'
require File.dirname(__FILE__) + '/Salesforce/rest/classes/contract.rb'
require File.dirname(__FILE__) + '/Salesforce/rest/classes/contract_feed.rb'
require File.dirname(__FILE__) + '/Salesforce/rest/classes/entity_subscription.rb'
require File.dirname(__FILE__) + '/Salesforce/rest/classes/feed_comment.rb'
require File.dirname(__FILE__) + '/Salesforce/rest/classes/feed_post.rb'
require File.dirname(__FILE__) + '/Salesforce/rest/classes/feed_tracked_change.rb'
require File.dirname(__FILE__) + '/Salesforce/rest/classes/group.rb'
require File.dirname(__FILE__) + '/Salesforce/rest/classes/group_member.rb'
require File.dirname(__FILE__) + '/Salesforce/rest/classes/lead.rb'
require File.dirname(__FILE__) + '/Salesforce/rest/classes/lead_feed.rb'
require File.dirname(__FILE__) + '/Salesforce/rest/classes/news_feed.rb'
require File.dirname(__FILE__) + '/Salesforce/rest/classes/opportunity.rb'
require File.dirname(__FILE__) + '/Salesforce/rest/classes/opportunity_feed.rb'
require File.dirname(__FILE__) + '/Salesforce/rest/classes/organization.rb'
require File.dirname(__FILE__) + '/Salesforce/rest/classes/product2.rb'
require File.dirname(__FILE__) + '/Salesforce/rest/classes/product2_feed.rb'
require File.dirname(__FILE__) + '/Salesforce/rest/classes/solution.rb'
require File.dirname(__FILE__) + '/Salesforce/rest/classes/solution_feed.rb'
require File.dirname(__FILE__) + '/Salesforce/rest/classes/solution_history.rb'
require File.dirname(__FILE__) + '/Salesforce/rest/classes/task.rb'
require File.dirname(__FILE__) + '/Salesforce/rest/classes/task_feed.rb'
require File.dirname(__FILE__) + '/Salesforce/rest/classes/user.rb'
require File.dirname(__FILE__) + '/Salesforce/rest/classes/user_feed.rb'
require File.dirname(__FILE__) + '/Salesforce/rest/classes/user_role.rb'
require File.dirname(__FILE__) + '/Salesforce/rest/classes/user_profile_feed.rb'

# OmniAuth/Salesforce Library
require File.dirname(__FILE__) + '/Salesforce/oauth2/forcedotcom.rb'

# Utility files
require File.dirname(__FILE__) + '/Salesforce/rest/asf_utility.rb'
