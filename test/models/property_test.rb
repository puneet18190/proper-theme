# == Schema Information
#
# Table name: properties
#
#  id          :integer          not null, primary key
#  address1    :string(255)
#  address2    :string(255)
#  address3    :string(255)
#  amount      :decimal(, )
#  bath        :integer
#  beds        :integer
#  parking     :boolean
#  image1      :string(255)
#  image2      :string(255)
#  image3      :string(255)
#  image4      :string(255)
#  image5      :string(255)
#  image6      :string(255)
#  description :text
#  date        :date
#  visibility  :boolean
#  created_at  :datetime
#  updated_at  :datetime
#  category    :string(255)
#  price       :decimal(, )
#  name        :string(255)
#  postcode    :string(255)
#  sold        :boolean
#  let         :boolean
#  featured    :boolean
#  s_date      :date
#  l_date      :date
#  r_date      :date
#  user_id     :integer
#  approve     :boolean          default(FALSE)
#  payment     :boolean          default(FALSE)
#  slug        :string(255)
#  validity    :datetime
#  coordinates :string(255)
#

require 'test_helper'

class PropertyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
