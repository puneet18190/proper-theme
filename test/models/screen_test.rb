# == Schema Information
#
# Table name: screens
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  status     :boolean          default(TRUE)
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class ScreenTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
