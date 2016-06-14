# == Schema Information
#
# Table name: miscellaneous_contacts
#
#  id         :integer          not null, primary key
#  first_name :string(255)
#  company    :string(255)
#  category   :string(255)
#  phone      :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#  last_name  :string(255)
#  position   :string(255)
#  mobile     :string(255)
#  web        :string(255)
#  notes      :text
#  avatar     :string(255)
#

require 'test_helper'

class MiscellaneousContactTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
