task :payment_remainder => :environment do
  properties = Property.where({payment: true})
  properties.each do |property|
  	unless property.validity.nil?
	    days = ((property.validity - DateTime.now.in_time_zone("UTC")) / 1.days)
	    if (days >= 0 && days <= 7)
	      UserMailer.payment_remainder(property).deliver
	    end
	end    
  end
end
