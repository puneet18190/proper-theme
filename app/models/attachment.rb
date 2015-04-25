# == Schema Information
#
# Table name: attachments
#
#  id            :integer          not null, primary key
#  attached_file :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

class Attachment < ActiveRecord::Base
  # attr_accessible :attached_file
  
  has_attached_file :attached_file

end
