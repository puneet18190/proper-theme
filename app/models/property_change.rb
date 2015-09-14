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
#  town              :string(255)
#  image1            :string(255)
#  image2            :string(255)
#  image3            :string(255)
#  image4            :string(255)
#  image5            :string(255)
#  image6            :string(255)
#  image7            :string(255)
#  image8            :string(255)
#  image9            :string(255)
#  image10           :string(255)
#  epc               :string(255)
#
# Indexes
#
#  index_property_changes_on_property_id  (property_id)
#

class PropertyChange < ActiveRecord::Base
  belongs_to :property
  attr_accessor :search_criteria
end
