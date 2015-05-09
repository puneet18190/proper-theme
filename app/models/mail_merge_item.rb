# == Schema Information
#
# Table name: mail_merge_items
#
#  id            :integer          not null, primary key
#  filename      :string(255)
#  url           :string(255)
#  m_type        :string(255)
#  mail_merge_id :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class MailMergeItem < ActiveRecord::Base
	belongs_to :mail_merge
end
