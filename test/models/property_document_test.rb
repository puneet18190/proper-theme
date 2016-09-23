# == Schema Information
#
# Table name: property_documents
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  url            :string(255)
#  date_completed :date
#  due_date       :date
#  property_id    :integer
#  created_at     :datetime
#  updated_at     :datetime
#  description    :text
#
# Indexes
#
#  index_property_documents_on_property_id  (property_id)
#

require 'test_helper'

class PropertyDocumentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
