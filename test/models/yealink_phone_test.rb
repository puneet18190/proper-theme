# == Schema Information
#
# Table name: yealink_phones
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  caller_id     :string(255)
#  department    :string(255)
#  status        :string(255)
#  call_duration :integer
#  callid        :string(255)
#  mac           :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

require 'test_helper'

class YealinkPhoneTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
