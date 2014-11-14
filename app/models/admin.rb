class Admin < ActiveRecord::Base
  mount_uploader :image, ImageUploader
end
