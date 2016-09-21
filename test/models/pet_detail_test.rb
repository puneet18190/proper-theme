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

require 'test_helper'

class PetDetailTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
