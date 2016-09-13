# == Schema Information
#
# Table name: blms
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  upload_time :datetime
#  created_at  :datetime
#  updated_at  :datetime
#  count       :integer          default(0)
#

require 'test_helper'

class BlmTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
