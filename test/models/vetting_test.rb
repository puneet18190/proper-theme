# == Schema Information
#
# Table name: vettings
#
#  id              :integer          not null, primary key
#  vetting_type    :string(255)
#  submission_date :date
#  outcome_date    :date
#  outcome         :string(255)
#  guarantor       :boolean
#  vetting_doc     :string(255)
#  property_id     :integer
#  created_at      :datetime
#  updated_at      :datetime
#

require 'test_helper'

class VettingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
