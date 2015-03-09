count = 0
Dashing.scheduler.every '10s' do
  @properties = Property.all
  @users = User.all
  a1= ["Active Properties"]
  b1= [(@properties.where(:payment=>true)).count]

  a2= ["Active Tenants", "Active Landlords"]
  b2= [@users.where("payment= ? AND status = ?", true,"tenant").count, @users.where("payment= ? AND status = ?", true,"landlord").count]

  a3= ["Total","In Year","In Month","In Week","Today"]
  b3= [@users.where(:status => "landlord").count, @users.where("created_at >= ? AND status = ?", Date.today.at_beginning_of_year,"landlord").count, @users.where("created_at >= ? AND status = ?", Date.today.at_beginning_of_month,"landlord").count, @users.where("created_at >= ? AND status = ?", Date.today.at_beginning_of_week,"landlord").count, @users.where("created_at >= ? AND status = ?", Date.today.at_beginning_of_day,"landlord").count]

  a4= ["Total","In Year","In Month","In Week","Today"]
  b4= [@users.where(:status => "tenant").count, @users.where("created_at >= ? AND status = ?", Date.today.at_beginning_of_year,"tenant").count, @users.where("created_at >= ? AND status = ?", Date.today.at_beginning_of_month,"tenant").count, @users.where("created_at >= ? AND status = ?", Date.today.at_beginning_of_week,"tenant").count, @users.where("created_at >= ? AND status = ?", Date.today.at_beginning_of_day,"tenant").count]

  Dashing.send_event('properties', { items: [{:label=>a1[count], :value=>b1[count] }]})
  Dashing.send_event('active_users', { items: [{:label=>a2[count], :value=>b2[count] }, {:label=>a2[count+1], :value=>b2[count+1] }]})
  Dashing.send_event('landlords', { items: [{:label=>a3[count], :value=>b3[count]},{:label=>a3[count+1], :value=>b3[count+1]},{:label=>a3[count+2], :value=>b3[count+2]},{:label=>a3[count+3], :value=>b3[count+3]},{:label=>a3[count+4], :value=>b3[count+4]}] })
  Dashing.send_event('tenants', { items: [{:label=>a4[count], :value=>b4[count]},{:label=>a4[count+1], :value=>b4[count+1]},{:label=>a4[count+2], :value=>b4[count+2]},{:label=>a4[count+3], :value=>b4[count+3]},{:label=>a4[count+4], :value=>b4[count+4]}] })

end

Dashing.scheduler.every '10s' do
  a5= ["In Year","In Month","In Week","Today","Online Visitors"]
  b5= []

  response = HTTParty.get('http://api.clicky.com/api/stats/4?site_id=100808775&sitekey=97ff050949c91f89&type=visitors&date=2015&output=json')
  data=JSON.parse(response.body)
  b5 << data.first['dates'].first["items"].first["value"]

  response = HTTParty.get('http://api.clicky.com/api/stats/4?site_id=100808775&sitekey=97ff050949c91f89&type=visitors&date=this-month&output=json')
  data=JSON.parse(response.body)
  b5 << data.first['dates'].first["items"].first["value"]

  response = HTTParty.get('http://api.clicky.com/api/stats/4?site_id=100808775&sitekey=97ff050949c91f89&type=visitors&date=this-week&output=json')
  data=JSON.parse(response.body)
  b5 << data.first['dates'].first["items"].first["value"]

  response = HTTParty.get('http://api.clicky.com/api/stats/4?site_id=100808775&sitekey=97ff050949c91f89&type=visitors&output=json')
  data=JSON.parse(response.body)
  b5 << data.first['dates'].first["items"].first["value"]

  response = HTTParty.get('http://api.clicky.com/api/stats/4?site_id=100808775&sitekey=97ff050949c91f89&type=visitors-online&output=json')
  data=JSON.parse(response.body)
  b5 << data.first['dates'].first["items"].first["value"]

  Dashing.send_event('visitors', { items: [{:label=>a5[count], :value=>b5[count]},{:label=>a5[count+1], :value=>b5[count+1]},{:label=>a5[count+2], :value=>b5[count+2]},{:label=>a5[count+3], :value=>b5[count+3]},{:label=>a5[count+4], :value=>b5[count+4]}] })
end

Dashing.scheduler.every '10s' do
  a5= ["In Year","In Month","In Week","Today"]
  b5= []

  response = HTTParty.get('http://api.clicky.com/api/stats/4?site_id=100808775&sitekey=97ff050949c91f89&type=visitors-unique&date=2015&output=json')
  data=JSON.parse(response.body)
  b5 << data.first['dates'].first["items"].first["value"]

  response = HTTParty.get('http://api.clicky.com/api/stats/4?site_id=100808775&sitekey=97ff050949c91f89&type=visitors-unique&date=this-month&output=json')
  data=JSON.parse(response.body)
  b5 << data.first['dates'].first["items"].first["value"]

  response = HTTParty.get('http://api.clicky.com/api/stats/4?site_id=100808775&sitekey=97ff050949c91f89&type=visitors-unique&date=this-week&output=json')
  data=JSON.parse(response.body)
  b5 << data.first['dates'].first["items"].first["value"]

  response = HTTParty.get('http://api.clicky.com/api/stats/4?site_id=100808775&sitekey=97ff050949c91f89&type=visitors-unique&output=json')
  data=JSON.parse(response.body)
  b5 << data.first['dates'].first["items"].first["value"]

  Dashing.send_event('visitors_unique', { items: [{:label=>a5[count], :value=>b5[count]},{:label=>a5[count+1], :value=>b5[count+1]},{:label=>a5[count+2], :value=>b5[count+2]},{:label=>a5[count+3], :value=>b5[count+3]}] })
end

Dashing.scheduler.every '10s' do
  a5= ["In Year","In Month","In Week","Today"]
  b5= []

  response = HTTParty.get('http://api.clicky.com/api/stats/4?site_id=100808775&sitekey=97ff050949c91f89&type=visitors-new&date=2015&output=json')
  data=JSON.parse(response.body)
  b5 << data.first['dates'].first["items"].first["value"]

  response = HTTParty.get('http://api.clicky.com/api/stats/4?site_id=100808775&sitekey=97ff050949c91f89&type=visitors-new&date=this-month&output=json')
  data=JSON.parse(response.body)
  b5 << data.first['dates'].first["items"].first["value"]

  response = HTTParty.get('http://api.clicky.com/api/stats/4?site_id=100808775&sitekey=97ff050949c91f89&type=visitors-new&date=this-week&output=json')
  data=JSON.parse(response.body)
  b5 << data.first['dates'].first["items"].first["value"]

  response = HTTParty.get('http://api.clicky.com/api/stats/4?site_id=100808775&sitekey=97ff050949c91f89&type=visitors-new&output=json')
  data=JSON.parse(response.body)
  b5 << data.first['dates'].first["items"].first["value"]

  Dashing.send_event('visitors_new', { items: [{:label=>a5[count], :value=>b5[count]},{:label=>a5[count+1], :value=>b5[count+1]},{:label=>a5[count+2], :value=>b5[count+2]},{:label=>a5[count+3], :value=>b5[count+3]}] })
end

Dashing.scheduler.every '10s' do
  a5= ["In Year","In Month","In Week","Today"]
  b5= []

  response = HTTParty.get('http://api.clicky.com/api/stats/4?site_id=100808775&sitekey=97ff050949c91f89&type=actions-pageviews&date=2015&output=json')
  data=JSON.parse(response.body)
  b5 << data.first['dates'].first["items"].first["value"]

  response = HTTParty.get('http://api.clicky.com/api/stats/4?site_id=100808775&sitekey=97ff050949c91f89&type=actions-pageviews&date=this-month&output=json')
  data=JSON.parse(response.body)
  b5 << data.first['dates'].first["items"].first["value"]

  response = HTTParty.get('http://api.clicky.com/api/stats/4?site_id=100808775&sitekey=97ff050949c91f89&type=actions-pageviews&date=this-week&output=json')
  data=JSON.parse(response.body)
  b5 << data.first['dates'].first["items"].first["value"]

  response = HTTParty.get('http://api.clicky.com/api/stats/4?site_id=100808775&sitekey=97ff050949c91f89&type=actions-pageviews&output=json')
  data=JSON.parse(response.body)
  b5 << data.first['dates'].first["items"].first["value"]

  a6= ["Actions per visitor"]
  response = HTTParty.get('http://api.clicky.com/api/stats/4?site_id=100808775&sitekey=97ff050949c91f89&type=actions-average&output=json')
  data=JSON.parse(response.body)
  b6 = []
  b6 << data.first['dates'].first["items"].first["value"]

  a7= ["Per visitor"]
  response = HTTParty.get('http://api.clicky.com/api/stats/4?site_id=100808775&sitekey=97ff050949c91f89&type=time-average-pretty&output=json')
  data=JSON.parse(response.body)
  b7 = []
  b7 << data.first['dates'].first["items"].first["value"]

  Dashing.send_event('page_views', { items: [{:label=>a5[count], :value=>b5[count]},{:label=>a5[count+1], :value=>b5[count+1]},{:label=>a5[count+2], :value=>b5[count+2]},{:label=>a5[count+3], :value=>b5[count+3]}] })
  Dashing.send_event('average_action', { items: [{:label=>a6[count], :value=>b6[count] }]})
  Dashing.send_event('average_time', { items: [{:label=>a7[count], :value=>b7[count] }]})
end

Dashing.scheduler.every '10s' do
  a5= ["In Year","In Month","In Week","Today"]
  b5= []

  response = HTTParty.get('http://api.clicky.com/api/stats/4?site_id=100808775&sitekey=97ff050949c91f89&type=bounce-rate&date=2015&output=json')
  data=JSON.parse(response.body)
  b5 << data.first['dates'].first["items"].first["value"]

  response = HTTParty.get('http://api.clicky.com/api/stats/4?site_id=100808775&sitekey=97ff050949c91f89&type=bounce-rate&date=this-month&output=json')
  data=JSON.parse(response.body)
  b5 << data.first['dates'].first["items"].first["value"]

  response = HTTParty.get('http://api.clicky.com/api/stats/4?site_id=100808775&sitekey=97ff050949c91f89&type=bounce-rate&date=this-week&output=json')
  data=JSON.parse(response.body)
  b5 << data.first['dates'].first["items"].first["value"]

  response = HTTParty.get('http://api.clicky.com/api/stats/4?site_id=100808775&sitekey=97ff050949c91f89&type=bounce-rate&output=json')
  data=JSON.parse(response.body)
  b5 << data.first['dates'].first["items"].first["value"]

  Dashing.send_event('bounce-rate', { items: [{:label=>a5[count], :value=>b5[count]},{:label=>a5[count+1], :value=>b5[count+1]},{:label=>a5[count+2], :value=>b5[count+2]},{:label=>a5[count+3], :value=>b5[count+3]}] })
end

Dashing.scheduler.every '20s' do
  @screen = Screen.all
  a1= ["Screen 3"]
  b1= [@screen.find_by_name("screen_3").status ? "Up" : "Down"]

  Dashing.send_event('screen_status', { items: [{:label=>a1[count], :value=>b1[count] }]})

end

Dashing.scheduler.every '15s' do
	require 'stripe'
  tp = Stripe::Plan.retrieve("plan_5")["amount"]
  lp = Stripe::Plan.retrieve("plan_10")["amount"]
  a8= ["Tenant Payment", "Landlord Payment"]
  b8= [tp.to_s, lp.to_s ]

  Dashing.send_event('payment', { items: [{:label=>a8[count], :value=>b8[count] },{:label=>a8[count+1], :value=>b8[count+1]}]})
end

Dashing.scheduler.every '10s' do
  a9= []
  b9= []

  response = HTTParty.get('http://api.clicky.com/api/stats/4?site_id=100808775&sitekey=97ff050949c91f89&type=searches-keywords&date=2015&output=json')
  data=JSON.parse(response.body)
  unless data.first['dates'].first["items"].empty?
	  (0..5).each do |obj|
		  a9 << data.first['dates'].first["items"][obj]["title"]
		  b9 << data.first['dates'].first["items"][obj]["value"]
	  end
   end

  Dashing.send_event('search_keyword', { items: [{:label=>a9[count], :value=>b9[count]},{:label=>a9[count+1], :value=>b9[count+1]},{:label=>a9[count+2], :value=>b9[count+2]},{:label=>a9[count+2], :value=>b9[count+2]},{:label=>a9[count+3], :value=>b9[count+3]},{:label=>a9[count+4], :value=>b9[count+4]}] })
end
