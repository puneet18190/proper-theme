# == Schema Information
#
# Table name: right_to_rents
#
#  id          :integer          not null, primary key
#  date_check  :date
#  expiry_doc  :date
#  doc_recheck :boolean
#  recheck_due :date
#  property_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'test_helper'

class RightToRentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
