# == Schema Information
#
# Table name: key_books
#
#  id          :integer          not null, primary key
#  property_id :integer
#  key_id      :integer
#  name        :string(255)
#  status      :string(255)
#  book_time   :datetime
#  person      :string(255)
#  notes       :text
#  created_at  :datetime
#  updated_at  :datetime
#

class KeyBook < ActiveRecord::Base
	belongs_to :property
end
