class Property < ActiveRecord::Base
  mount_uploader :image1, Image1Uploader
  mount_uploader :image2, Image2Uploader
  mount_uploader :image3, Image3Uploader
  mount_uploader :image4, Image4Uploader
  mount_uploader :image5, Image5Uploader
  mount_uploader :image6, Image6Uploader
  validates :name, presence: true, length: { maximum: 20 }
  validates :address1, presence: :true
  validates :address2, presence: :true
  validates :address3, presence: :true
  validates :price, presence: :true
  validates :amount, presence: :true
  validates :postcode, presence: :true
  validates :beds, presence: :true
  validates :bath, presence: :true
  validates :parking, presence: :true
  validates :category, presence: :true
  validates :description, presence: :true
  validates :date, presence: :true
  validates :visibility, presence: :true
  validates_presence_of :image1
  validates_presence_of :image2
  validates_presence_of :image3
  validates_presence_of :image4
  validates_presence_of :image5
  validates_presence_of :image6
end
