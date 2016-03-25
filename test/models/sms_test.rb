# == Schema Information
#
# Table name: sms
#
#  id          :integer          not null, primary key
#  originator  :string(255)
#  destination :string(255)
#  message     :text
#  created_at  :datetime
#  updated_at  :datetime
#

require 'test_helper'

class SmsTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
