# == Schema Information
#
# Table name: miscellaneous_contacts
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  company    :string(255)
#  category   :string(255)
#  phone      :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class MiscellaneousContact < ActiveRecord::Base
end
