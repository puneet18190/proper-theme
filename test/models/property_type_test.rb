# == Schema Information
#
# Table name: property_types
#
#  id         :integer          not null, primary key
#  p_type     :string(255)
#  search     :string(255)
#  p_id       :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class PropertyTypeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
