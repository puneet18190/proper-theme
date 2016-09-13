# == Schema Information
#
# Table name: properties
#
#  id                   :integer          not null, primary key
#  address1             :string(255)
#  address2             :string(255)
#  address3             :string(255)
#  amount               :decimal(, )
#  bath                 :integer
#  beds                 :integer
#  parking              :boolean
#  image1               :string(255)
#  image2               :string(255)
#  image3               :string(255)
#  image4               :string(255)
#  image5               :string(255)
#  image6               :string(255)
#  description          :text
#  date                 :date
#  visibility           :boolean
#  created_at           :datetime
#  updated_at           :datetime
#  category             :string(255)
#  price                :decimal(, )
#  name                 :string(255)
#  postcode             :string(255)
#  sold                 :boolean
#  let                  :boolean
#  featured             :boolean
#  s_date               :date
#  l_date               :date
#  r_date               :date
#  user_id              :integer
#  approve              :boolean          default(FALSE)
#  payment              :boolean          default(FALSE)
#  slug                 :string(255)
#  validity             :datetime
#  coordinates          :string(255)
#  agent_id             :integer
#  image7               :string(255)
#  image8               :string(255)
#  image9               :string(255)
#  image10              :string(255)
#  latitude             :float
#  longitude            :float
#  radius               :string(255)
#  approval_status      :string(255)      default("false")
#  short_description    :text
#  gas_ch               :string(255)      default("No")
#  glazing              :boolean          default(FALSE)
#  parking_status       :string(255)      default("none")
#  car                  :integer
#  tag_line             :text
#  garden               :string(255)      default("No")
#  dg                   :string(255)      default(FALSE)
#  seal_approved        :boolean          default(FALSE)
#  property_type        :string(255)
#  pets                 :string(255)      default("No")
#  ensuite              :string(255)      default("No")
#  town                 :string(255)
#  status               :string(255)
#  postcode1            :string(255)
#  qualifier            :string(255)
#  summary              :text
#  furnished            :string(255)
#  feature1             :string(255)
#  feature2             :string(255)
#  let_type_id          :string(255)      default("Not Specified")
#  let_furn_id          :string(255)      default("Not Specified")
#  epc                  :string(255)
#  brochure_link        :string(255)
#  let_date_available   :datetime
#  otm                  :boolean          default(TRUE)
#  accredited           :boolean
#  licensed             :boolean
#  tenant_criteria      :string(255)
#  cp12                 :string(255)
#  esc                  :string(255)
#  bond                 :string(255)
#  deal                 :text
#  stage                :string(255)
#  managed              :boolean
#  board                :boolean
#  tenant_id            :integer
#  let_agreed_date      :datetime
#  sold_date            :datetime
#  property_create_user :string(255)
#  marketing_notes      :text
#  epc_date_complete    :date
#  epc_due_date         :date
#  cp12_date_complete   :date
#  cp12_due_date        :date
#  esc_date_complete    :date
#  esc_due_date         :date
#  mouse_price          :boolean          default(TRUE)
#  dss_move             :boolean          default(TRUE)
#  home                 :boolean          default(TRUE)
#  wonder_property      :boolean          default(TRUE)
#  key_assign_date      :datetime
#  key_unassign_date    :datetime
#  zoopla               :boolean          default(TRUE)
#  nethouse             :boolean          default(TRUE)
#  let_rent_frequency   :integer          default(1)
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
