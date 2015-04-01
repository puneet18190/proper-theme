# == Schema Information
#
# Table name: directory_entries
#
#  id         :integer          not null, primary key
#  Name       :string(255)
#  Telephone  :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class DirectoryEntry < ActiveRecord::Base
end
