class Property < ActiveRecord::Base
  mount_uploader :image1, Image1Uploader
  mount_uploader :image2, Image2Uploader
  mount_uploader :image3, Image3Uploader
  mount_uploader :image4, Image4Uploader
  mount_uploader :image5, Image5Uploader
  mount_uploader :image6, Image6Uploader
  validates :name, presence: true, length: { maximum: 20 }
  validates_presence_of :image1, :address1, :address2, :address3, :price, :postcode, :beds, :bath, :description
end
