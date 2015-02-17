# == Schema Information
#
# Table name: contacts
#
#  id             :integer          not null, primary key
#  first_name     :string(255)
#  last_name      :string(255)
#  email_id       :string(255)
#  contact_number :string(255)
#  comments       :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

require 'test_helper'

class ContactTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
