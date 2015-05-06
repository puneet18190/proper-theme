# == Schema Information
#
# Table name: properties
#
#  id              :integer          not null, primary key
#  address1        :string(255)
#  address2        :string(255)
#  address3        :string(255)
#  amount          :decimal(, )
#  bath            :integer
#  beds            :integer
#  parking         :boolean
#  image1          :string(255)
#  image2          :string(255)
#  image3          :string(255)
#  image4          :string(255)
#  image5          :string(255)
#  image6          :string(255)
#  description     :text
#  date            :date
#  visibility      :boolean
#  created_at      :datetime
#  updated_at      :datetime
#  category        :string(255)
#  price           :decimal(, )
#  name            :string(255)
#  postcode        :string(255)
#  sold            :boolean
#  let             :boolean
#  featured        :boolean
#  s_date          :date
#  l_date          :date
#  r_date          :date
#  user_id         :integer
#  approve         :boolean          default(FALSE)
#  payment         :boolean          default(FALSE)
#  slug            :string(255)
#  validity        :datetime
#  coordinates     :string(255)
#  agent_id        :integer
#  image7          :string(255)
#  image8          :string(255)
#  image9          :string(255)
#  image10         :string(255)
#  latitude        :float
#  longitude       :float
#  radius          :string(255)
#  approval_status :string(255)      default("false")
#
# Indexes
#
#  index_properties_on_slug  (slug) UNIQUE
#

class Property < ActiveRecord::Base
	extend FriendlyId
  	friendly_id :name, use: :slugged

  belongs_to :user
  belongs_to :agent
  mount_uploader :image1, Image1Uploader
  mount_uploader :image2, Image2Uploader
  mount_uploader :image3, Image3Uploader
  mount_uploader :image4, Image4Uploader
  mount_uploader :image5, Image5Uploader
  mount_uploader :image6, Image6Uploader
  mount_uploader :image7, Image7Uploader
  mount_uploader :image8, Image8Uploader
  mount_uploader :image9, Image9Uploader
  mount_uploader :image10, Image10Uploader

  process_in_background :image1
  process_in_background :image2
  process_in_background :image3
  process_in_background :image4
  process_in_background :image5
  process_in_background :image6
  process_in_background :image7
  process_in_background :image8
  process_in_background :image9
  process_in_background :image10

  validates :name, presence: true, length: { maximum: 20 }
  validates_presence_of :address1, :address2, :address3, :price, :postcode, :beds, :bath, :description
  geocoded_by :address

end
