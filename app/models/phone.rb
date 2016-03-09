# == Schema Information
#
# Table name: phones
#
#  id             :integer          not null, primary key
#  callerid       :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  call_action    :string(255)
#  dataname       :string(255)
#  local          :string(255)
#  remote         :string(255)
#  display_local  :string(255)
#  display_remote :string(255)
#

class Phone < ActiveRecord::Base
	def self.call(extension, destination)
		HTTParty.post("https://call-api.gradwell.com/0.9.3/call",:body=>{ 
	        :auth=>'RJFICF9O59PHQXOZ7M2B98DP7O', 
	        :extension=>extension, 
	        :destination=>destination
	    })
	end
end

#post https://call-api.gradwell.com/0.9.3/call 
#auth = RJFICF9O59PHQXOZ7M2B98DP7O
#extension = 2018700
#destination = 447903351304
