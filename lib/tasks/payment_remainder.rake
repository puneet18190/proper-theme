task :payment_remainder => :environment do
  users = User.where({payment: true})
  users.each do |user|
  	unless user.validity.nil?
	    days = ((user.validity - DateTime.now.in_time_zone("UTC")) / 1.days)
	    if (days >= 0 && days <= 7)
	      UserMailer.payment_remainder(user, days).deliver
	    end
	end    
  end
end
