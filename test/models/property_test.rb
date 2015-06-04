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
#  gas_ch            :boolean          default(FALSE)
#  glazing           :boolean          default(FALSE)
#  parking_status    :string(255)      default("none")
#  car               :integer
#  tag_line          :text
#  garden            :boolean          default(FALSE)
#  dg                :boolean          default(FALSE)
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
