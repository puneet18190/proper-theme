current_valuation = 0

Dashing.scheduler.every '2s' do
  last_valuation = current_valuation
  current_valuation = rand(100)

  Dashing.send_event('valuation', { current: current_valuation, last: last_valuation })
  Dashing.send_event('synergy',   { value: rand(100) })
end

  # @users = User.all 
  # @tenants = @users.where(:status => "tenants")
  # @landlords = @users.where(:status => "landlord")

  # @a=@users.where(:status=>"tenant").group("DATE_TRUNC('month', created_at)").count 
  # @a.each{|m| puts "Month: #{m[0].strftime("%b")}, Count: #{m[1]}"} 

  # User.where('created_at >= ?', Date.today.at_beginning_of_month).count 

  #@properties = Property.all
  #@active_properties = @properties.where(:payment=>true)

  #@active_tenants = @tenants.where(:payment=>true)
  #@active_landlords = @landlords.where(:payment=>true)

