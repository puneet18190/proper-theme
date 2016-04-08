# == Schema Information
#
# Table name: keys
#
#  id          :integer          not null, primary key
#  key_number  :integer
#  key_status  :string(255)      default("unassign")
#  property_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Key < ActiveRecord::Base
	belongs_to :property
end
