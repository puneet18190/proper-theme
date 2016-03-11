# == Schema Information
#
# Table name: contact_notes
#
#  id         :integer          not null, primary key
#  notes      :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_contact_notes_on_user_id  (user_id)
#

require 'test_helper'

class ContactNoteTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
