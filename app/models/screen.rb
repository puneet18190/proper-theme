# == Schema Information
#
# Table name: screens
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  status     :boolean          default(TRUE)
#  created_at :datetime
#  updated_at :datetime
#

class Screen < ActiveRecord::Base
	# def self.save_file(upload)
	#     name =  upload['datafile'].original_filename
	#     directory = "public/doc"
	#     # create the file path
	#     path = File.join(directory, name)
	#     # write the file
	#     File.open(path, "wb") { |f| f.write(upload['datafile'].read) }
	#   end
end
