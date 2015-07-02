# == Schema Information
#
# Table name: properties
#
#  id                :integer          not null, primary key
#  address1          :string(255)
#  address2          :string(255)
#  address3          :string(255)
#  amount            :decimal(, )
#  bath              :integer
#  beds              :integer
#  parking           :boolean
#  image1            :string(255)
#  image2            :string(255)
#  image3            :string(255)
#  image4            :string(255)
#  image5            :string(255)
#  image6            :string(255)
#  description       :text
#  date              :date
#  visibility        :boolean
#  created_at        :datetime
#  updated_at        :datetime
#  category          :string(255)
#  price             :decimal(, )
#  name              :string(255)
#  postcode          :string(255)
#  sold              :boolean
#  let               :boolean
#  featured          :boolean
#  s_date            :date
#  l_date            :date
#  r_date            :date
#  user_id           :integer
#  approve           :boolean          default(FALSE)
#  payment           :boolean          default(FALSE)
#  slug              :string(255)
#  validity          :datetime
#  coordinates       :string(255)
#  agent_id          :integer
#  image7            :string(255)
#  image8            :string(255)
#  image9            :string(255)
#  image10           :string(255)
#  latitude          :float
#  longitude         :float
#  radius            :string(255)
#  approval_status   :string(255)      default("false")
#  short_description :text
#  gas_ch            :string(255)      default("No")
#  glazing           :boolean          default(FALSE)
#  parking_status    :string(255)      default("none")
#  car               :integer
#  tag_line          :text
#  garden            :string(255)      default("No")
#  dg                :string(255)      default(FALSE)
#  seal_approved     :boolean          default(FALSE)
#  pets              :string(255)      default("No")
#  ensuite           :string(255)      default("No")
#  town              :string(255)
#  status            :string(255)
#  postcode1         :string(255)
#  qualifier         :string(255)
#  summary           :text
#  furnished         :string(255)
#  feature1          :string(255)
#  feature2          :string(255)
#  property_type     :integer
#  let_type_id       :integer
#  let_furn_id       :integer
#  epc               :string(255)
#  brochure_link     :string(255)
#
# Indexes
#
#  index_properties_on_slug  (slug) UNIQUE
#

require 'test_helper'

class PropertyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
