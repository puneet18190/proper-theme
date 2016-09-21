# == Schema Information
#
# Table name: guarantors
#
#  id            :integer          not null, primary key
#  firstname     :string(255)
#  lastname      :string(255)
#  previous_name :string(255)
#  dob           :string(255)
#  address1      :string(255)
#  address2      :string(255)
#  address3      :string(255)
#  postcode      :string(255)
#  home_tel      :string(255)
#  mobile_tel    :string(255)
#  email         :string(255)
#  emp_status    :string(255)
#  emp_from      :string(255)
#  job_title     :string(255)
#  annual_inc    :string(255)
#  ref_name      :string(255)
#  ref_job       :string(255)
#  ref_company   :string(255)
#  ref_address   :string(255)
#  ref_tel       :string(255)
#  ref_email     :string(255)
#  ref_rel       :string(255)
#  outcome       :string(255)
#  add_info      :text
#  property_id   :integer
#  created_at    :datetime
#  updated_at    :datetime
#

require 'test_helper'

class GuarantorTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
