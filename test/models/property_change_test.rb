# == Schema Information
#
# Table name: property_changes
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  address1          :string(255)
#  address2          :string(255)
#  address3          :string(255)
#  postcode          :string(255)
#  postcode1         :string(255)
#  property_type     :integer
#  beds              :integer
#  bath              :integer
#  parking_status    :string(255)      default("none")
#  car               :integer
#  ensuite           :string(255)      default("No")
#  let_type_id       :string(255)      default("Not Specified")
#  let_furn_id       :string(255)      default("Not Specified")
#  gas_ch            :string(255)      default("No")
#  garden            :string(255)      default("No")
#  dg                :string(255)
#  pets              :string(255)      default("No")
#  feature1          :string(255)
#  feature2          :string(255)
#  category          :string(255)
#  status            :string(255)
#  price             :decimal(, )
#  tag_line          :text
#  summary           :text
#  short_description :text
#  description       :text
#  property_id       :integer
#  created_at        :datetime
#  updated_at        :datetime
#
# Indexes
#
#  index_property_changes_on_property_id  (property_id)
#

require 'test_helper'

class PropertyChangeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
