# == Schema Information
#
# Table name: services
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  telephone  :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Service < ActiveRecord::Base
end
