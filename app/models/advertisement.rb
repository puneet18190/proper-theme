# == Schema Information
#
# Table name: advertisements
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :string(255)
#  email       :string(255)
#  phone       :string(255)
#  image       :string(255)
#  expiry_date :date
#  created_at  :datetime
#  updated_at  :datetime
#

class Advertisement < ActiveRecord::Base
  mount_uploader :image, ImageUploader
end
