# == Schema Information
#
# Table name: contact_agents
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  message    :string(255)
#  created_at :datetime
#  updated_at :datetime
#  agent_id   :integer
#  page_link  :string(255)
#

require 'test_helper'

class ContactAgentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
