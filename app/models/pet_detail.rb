# == Schema Information
#
# Table name: pet_details
#
#  id          :integer          not null, primary key
#  pet_name    :string(255)
#  pet_type    :string(255)
#  pet_breed   :string(255)
#  pet_age     :string(255)
#  property_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class PetDetail < ActiveRecord::Base
	belongs_to :property
end
