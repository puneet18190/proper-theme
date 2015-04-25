# == Schema Information
#
# Table name: attachments
#
#  id                         :integer          not null, primary key
#  attached_file_file_name    :string(255)
#  attached_file_content_type :string(255)
#  attached_file_file_size    :integer
#  attached_file_updated_at   :datetime
#  created_at                 :datetime
#  updated_at                 :datetime
#  message_id                 :integer
#

class Attachment < ActiveRecord::Base
  # attr_accessible :attached_file
  
  has_attached_file :attached_file
  belongs_to :message

end
