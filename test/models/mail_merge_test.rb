# == Schema Information
#
# Table name: mail_merges
#
#  id         :integer          not null, primary key
#  filename   :string(255)
#  url        :string(255)
#  m_type     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class MailMergeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
