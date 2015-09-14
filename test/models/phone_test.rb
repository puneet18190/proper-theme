# == Schema Information
#
# Table name: phones
#
#  id          :integer          not null, primary key
#  callerid    :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  call_action :string(255)
#  dataname    :string(255)
#

require 'test_helper'

class PhoneTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
