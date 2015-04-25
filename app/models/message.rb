# == Schema Information
#
# Table name: messages
#
#  id         :integer          not null, primary key
#  subject    :text
#  to         :string(255)
#  from       :string(255)
#  html_body  :text
#  text_body  :text
#  created_at :datetime
#  updated_at :datetime
#

class Message < ActiveRecord::Base
  # attr_accessible :from, :html_body, :subject, :text_body, :to
end
