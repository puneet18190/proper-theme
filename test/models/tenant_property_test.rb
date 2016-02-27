# == Schema Information
#
# Table name: tenant_properties
#
#  id          :integer          not null, primary key
#  property_id :integer
#  tenant_id   :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'test_helper'

class TenantPropertyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
