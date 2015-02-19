# == Schema Information
#
# Table name: settings
#
#  id          :integer          not null, primary key
#  admin_image :string(255)
#  admin_text  :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

require 'test_helper'

class SettingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
