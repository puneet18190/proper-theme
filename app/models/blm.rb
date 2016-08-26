# == Schema Information
#
# Table name: blms
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  upload_time :datetime
#  created_at  :datetime
#  updated_at  :datetime
#

class Blm < ActiveRecord::Base
end
