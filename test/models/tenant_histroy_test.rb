# == Schema Information
#
# Table name: tenant_histroys
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  tenancy_start_date :date
#  tenancy_end_date   :date
#  property_id        :integer
#  created_at         :datetime
#  updated_at         :datetime
#

require 'test_helper'

class TenantHistroyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
