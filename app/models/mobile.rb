# == Schema Information
#
# Table name: mobiles
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  telephone  :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Mobile < ActiveRecord::Base
end
