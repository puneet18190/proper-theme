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
#

class ContactAgent < ActiveRecord::Base
  belongs_to :contact
end
