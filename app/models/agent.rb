# == Schema Information
#
# Table name: agents
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  address    :string(255)
#  phone      :string(255)
#  image      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Agent < ActiveRecord::Base
  has_many :properties
  mount_uploader :image, ImageUploader
end
