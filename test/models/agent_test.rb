# == Schema Information
#
# Table name: agents
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  address    :string(255)
#  phone      :string(255)
#  image      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class AgentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
