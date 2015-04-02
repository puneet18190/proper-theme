# == Schema Information
#
# Table name: provisions
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  url        :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Provision < ActiveRecord::Base
end
