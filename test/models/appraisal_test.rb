# == Schema Information
#
# Table name: appraisals
#
#  id         :integer          not null, primary key
#  firstname  :string(255)
#  lastname   :string(255)
#  email      :string(255)
#  contact    :string(255)
#  status     :string(255)
#  comments   :text
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class AppraisalTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
