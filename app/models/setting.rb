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
#  screen_text          :string(255)
#  newest_screen        :boolean
#  newest_screen_text   :string(255)
#  oldest_screen        :boolean
#  oldest_screen_text   :string(255)
#  featured_screen      :boolean
#  featured_screen_text :string(255)
#  cycle_screen         :boolean
#  cycle_screen_text    :string(255)
#  random_screen        :boolean
#  random_screen_text   :string(255)
#  newest_inside_text   :string(255)
#  newest_inside        :boolean
#  oldest_inside_text   :string(255)
#  oldest_inside        :boolean
#  featured_inside_text :string(255)
#  featured_inside      :boolean
#  cycle_inside_text    :string(255)
#  cycle_inside         :boolean
#  random_inside_text   :string(255)
#  random_inside        :boolean
#

class Setting < ActiveRecord::Base
  mount_uploader :admin_image, AdminImageUploader
end
