# == Schema Information
#
# Table name: settings
#
#  id                   :integer          not null, primary key
#  admin_image          :string(255)
#  admin_text           :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  property_description :text
#

class Setting < ActiveRecord::Base
  mount_uploader :admin_image, AdminImageUploader
end
