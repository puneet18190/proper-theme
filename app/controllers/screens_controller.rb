class ScreensController < ApplicationController
	require 'json'
	require 'pat'
	require 'rqrcode_png' 
	require 's3'
	require 'httparty'
	respond_to :html, :xml, :json
	layout proc { false if request.xhr? }
	protect_from_forgery :except => ["update_screen_status", "mail_merge_uploadfile"]
	def page1
		render '/screens/screen2/page1'
	end

	def page2
		render '/screens/screen2/page2'
	end

	def screen1
		render '/screens/screen1/screen1', :layout => "screen_layout"
	end

	def screen2
		render '/screens/screen2/screen2', :layout => "screen_layout"
	end

	def screen3
		@properties = Property.where(:visibility=>true).last(5)
		render '/screens/screen3/screen3', :layout => "screen_layout"
	end	

	def screen_properties_detail
		begin
			@data = Property.find(params[:property_id])
			Screen.find_by_name("screen_"+params[:screen_id].to_s).update_attributes(:status => params[:status])
			render '/screens/screen3/screen_properties_detail'
		rescue
			Screen.find_by_name("screen_"+params[:screen_id].to_s).update_attributes(:status => params[:status])
		end	
	end

	def newest_properties_detail
		@data = Property.find(params[:property_id])
		@postcode = Pat.get(@data.postcode.to_s)
		@datapat = JSON.parse(@postcode.body)
		render '/screens/newest/newest_properties_detail'
	end

	def impress
		render :layout => false
	end	

	def update_screen_status
		Screen.find_by_name("screen_"+params[:screen_id].to_s).update_attributes(:status => params[:status])
		render :json => {:status => "ok"}.to_json
  	end

	def community
  #   	@advertisements = []
  #   	@advertisements = Advertisement.all
  #   	@advertisements_l = @advertisements[0..1]
  #   	@advertisements_m = @advertisements[2..3]
  #   	@advertisements_r = @advertisements[4..5]
  #   	@advertisements_x = @advertisements[6..7]
		# render '/screens/community/community_detail', :layout => "screen_layout"
		@advertisements = []
	    @advertisements_t = []
	    @advertisements_b = []
	    @advertisements = Advertisement.all
	    @total = @advertisements.count
	    @half = @total/2
	    # @count_lt = @total < 3 ? (3-@total) : 0
	    (0..(@half-1)).each do |rec|
	      @advertisements_t << @advertisements[rec]
	    end
	    ((@half)..(@total-1)).each do |dat|
	      @advertisements_b << @advertisements[dat]
	    end
	    render '/properties/advertisements', :layout => "screen_layout"
	end

	def newest
		@text = Setting.all[0].newest_screen_text
		@status = Setting.all[0].newest_screen
		@properties = Property.where(:visibility=>true,:approval_status=>"approved").last(5)
		render '/screens/oldest/newest', :layout => "screen_layout"
	end

	def featured_properties
		@text = Setting.all[0].featured_screen_text
		@status = Setting.all[0].featured_screen
		@properties = Property.where(:featured=>true,:approval_status=>"approved",:visibility=>true).last(5)
		render '/screens/oldest/featured', :layout => "screen_layout"
	end	

	def random_properties
		@text = Setting.all[0].random_screen_text
		@status = Setting.all[0].random_screen
		@properties = Property.where(:visibility=>true,:approval_status=>"approved").sample(5)
		render '/screens/oldest/random', :layout => "screen_layout"
	end	
	def cycle
		@text = Setting.all[0].cycle_screen_text
		@status = Setting.all[0].cycle_screen
		@properties = Property.where(:visibility => true,:approval_status=>"approved")
		render '/screens/oldest/cycle', :layout => "screen_layout"
	end	

	def oldest
		@text = Setting.all[0].oldest_screen_text
		@status = Setting.all[0].oldest_screen
		@properties = Property.where(:visibility=>true,:approval_status=>"approved").first(10)
		render '/screens/oldest/oldest', :layout => "screen_layout"
	end	

	def oldest_properties_detail
		if params[:property_id] == "0"
			if params[:screen] == "featured_properties"
				@text = Setting.all[0].featured_screen_text
			elsif params[:screen] == "random_properties"
				@text = Setting.all[0].random_screen_text
			else
				@text = Setting.all[0].send("#{params[:screen]}_screen_text")
			end
			render '/screens/newest/screen_html'#, :layout => false
		else
		@data = Property.find(params[:property_id])
		# @postcode = Pat.get(@data.postcode.to_s)
		# @datapat = JSON.parse(@postcode.body)
		url = "http://#{request.host_with_port}/properties_detail/#{@data.id}"
		@qr = RQRCode::QRCode.new(url,:size => 10).to_img.resize(200, 200).to_data_url
		render '/screens/oldest/oldest_properties_detail'
		end
	end

	def newest_inside
		@text = Setting.all[0].newest_inside_text
		@status = Setting.all[0].newest_inside
		@properties = Property.where(:visibility=>true,:approval_status=>"approved").last(5)
		render '/screens/inside/newest', :layout => "screen_layout"
	end

	def featured_inside
		@text = Setting.all[0].featured_inside_text
		@status = Setting.all[0].featured_inside
		@properties = Property.where(:featured=>true,:approval_status=>"approved",:visibility=>true).last(5)
		render '/screens/inside/featured', :layout => "screen_layout"
	end	

	def random_inside
		@text = Setting.all[0].random_inside_text
		@status = Setting.all[0].random_inside
		@properties = Property.where(:visibility=>true,:approval_status=>"approved").sample(5)
		render '/screens/inside/random', :layout => "screen_layout"
	end	

	def cycle_inside
		@text = Setting.all[0].cycle_inside_text
		@status = Setting.all[0].cycle_inside
		@properties = Property.where(:visibility => true,:approval_status=>"approved")
		render '/screens/inside/cycle', :layout => "screen_layout"
	end	

	def oldest_inside
		@text = Setting.all[0].oldest_inside_text
		@status = Setting.all[0].oldest_inside
		@properties = Property.where(:visibility=>true,:approval_status=>"approved").first(10)
		render '/screens/inside/oldest', :layout => "screen_layout"
	end	

	def inside_properties_detail
		if params[:property_id] == "0"
			# if params[:screen] == "featured_properties"
			# 	@text = Setting.all[0].featured_screen_text
			# elsif params[:screen] == "random_properties"
			# 	@text = Setting.all[0].random_screen_text
			# else
				@text = Setting.all[0].send("#{params[:screen]}_text")
			# end
			render '/screens/newest/screen_html'#, :layout => false
		else
		@data = Property.find(params[:property_id])
		@postcode = Pat.get(@data.postcode.to_s)
		@datapat = JSON.parse(@postcode.body)
		url = "http://#{request.host_with_port}/properties_detail/#{@data.id}"
		@qr = RQRCode::QRCode.new(url,:size => 10).to_img.resize(200, 200).to_data_url
		render '/screens/inside/inside_properties_detail'
		end
	end

	def bigscreen
	    @title = []
	    @description = []
	    response = Nokogiri::HTML(open("http://feeds.bbci.co.uk/news/uk/rss.xml?edition=uk"))
	    sleep 2
	    response.css('title').each do |t|
	      @title.push(t.text)
	    end  
	    response.css('description').each do |t|
	      @description.push(t.text)
	    end  

	    @p_title = []
	    @p_description = []
	    agent = Mechanize.new
	    page = agent.get('http://www.propertyreporter.co.uk/rss.asp')
	    response = Nokogiri::XML::Document.parse(page.body, nil, "UTF-8")
	    response.css('title').each do |t|
	      @p_title.push(t.text)
	    end  
	    response.css('description').each do |t|
	      @p_description.push(t.text)
	    end
	    render :layout => "test_layout"

	end  

	def provisioning
		@data  = Provision.all
		render :layout => "screen_layout"
	end

	def provisioning_files
		#if request.ip == "82.68.0.86" || request.ip == "82.68.180.14" 
			render "/screens/provisioning/#{params[:id]}.#{params[:format]}", :layout => false
		#else
		#	redirect_to root_url, alert: "IP: #{request.ip} is not Authorized." 
		#end					
	end	

	def phones
		if request.ip == "82.68.0.86" || request.ip == "82.68.180.14" 
			@data = DirectoryEntry.all.select(:Name, :Telephone)
		else
			redirect_to root_url, alert: "IP: #{request.ip} is not Authorized. " 
		end			
	end	

	def uploadfile
		@data = Provision.create(:name => params[:filename], :url => params[:url])
	    respond_to do |format|
	      format.js
	    end
	end

	def landlords
		if request.ip == "82.68.0.86" || request.ip == "82.68.180.14" 
			@data = User.all.where("status = ?", "landlord")
		else
			redirect_to root_url, alert: "IP: #{request.ip} is not Authorized. " 
		end	
	end
	
	def tenants
		if request.ip == "82.68.0.86" || request.ip == "82.68.180.14" 
			@data = User.all.where("status = ?", "tenant")
		else
			redirect_to root_url, alert: "IP: #{request.ip} is not Authorized. " 
		end	
	end	

	def mobiles
		#if request.ip == "82.68.0.86" || request.ip == "82.68.180.14" 
			@data = Mobile.all.select(:name, :telephone)
		# else
		# 	redirect_to root_url, alert: "IP: #{request.ip} is not Authorized." 
		# end			
	end
	def services
		if request.ip == "82.68.0.86" || request.ip == "82.68.180.14" 
			@data = Service.all.select(:name, :telephone)
		else
			redirect_to root_url, alert: "IP: #{request.ip} is not Authorized. " 
		end					
	end	

	def delete_file_from_s3
		service = S3::Service.new(:access_key_id => ENV['AWS_ACCESS_KEY'],:secret_access_key => ENV['AWS_SECRET_KEY'])
		bucket = service.buckets.find("sealpropertiesus")

		begin
			a= params[:url].split("https://sealpropertiesus.s3.amazonaws.com/").last
			object = bucket.objects.find(a)
			if object
				object.destroy
				if params[:mailmerge]
					MailMerge.find_by_id(params[:id]).mail_merge_items.each do |obj|
						bucket.objects.find(obj.url.split("https://sealpropertiesus.s3.amazonaws.com/").last).destroy
						obj.delete
					end	
					MailMerge.find_by_id(params[:id]).delete
				elsif params[:mailmergeitem]
					MailMergeItem.find_by_id(params[:id]).delete		
				else	
					Provision.find_by_id(params[:id]).delete
				end	
				redirect_to :back
			end	
		rescue
			redirect_to :back
		end	
	end	

	def mail_merge
		@data = MailMerge.all
		render :layout => "screen_layout"
	end
		
	def mail_merge_uploadfile
		@data = MailMerge.create(:filename => params[:filename], :url => params[:url], :m_type => "template")
		['puneet','sumeet'].each_with_index do |user,i|
			report = ODFReport::Report.new(open(params[:url])) do |r|
  				r.add_field('BODY', "#{user}")
			end

			service = S3::Service.new(:access_key_id => ENV['AWS_ACCESS_KEY'],:secret_access_key => ENV['AWS_SECRET_KEY'])
			bucket = service.buckets.find("sealpropertiesus")
			a=DateTime.now
			a=a.year.to_s+a.month.to_s.rjust(2,'0')+a.day.to_s.rjust(2,'0')+a.hour.to_s+a.minute.to_s+a.second.to_s
			object = bucket.objects.build(a+"file#{i}.odt")
			object.content = report.generate()
			object.save
			response = HTTParty.get("http://online.verypdf.com/api/?apikey=BF8763B8F38C40FEC5DB3F109FA034AE10F66497&app=doc2any&infile=https://sealpropertiesus.s3.amazonaws.com/#{a}file#{i}.odt&outfile=#{a}file#{i}.pdf")
			pdf_url = response.body.split("[Output]").last.gsub("<br>","")
			@data.mail_merge_items.create(:filename => a+"file#{i}.odt", :url=>"https://sealpropertiesus.s3.amazonaws.com/"+a+"file#{i}.odt",:m_type=>"item", :pdf_url => pdf_url)			    
		end	
		respond_to do |format|
	      format.js
	    end
	end	

	def api_for_dashing
	  @properties = Property.all
	  @users = User.all
	  properties = @properties.where(:payment=>true).count
	  tenants = @users.where("payment= ? AND status = ?", true,"tenant").count
	  landlords = @users.where("payment= ? AND status = ?", true,"landlord").count
	  total_ll = @users.where(:status => "landlord").count
	  year_ll = @users.where("created_at >= ? AND status = ?", Date.today.at_beginning_of_year,"landlord").count
	  month_ll = @users.where("created_at >= ? AND status = ?", Date.today.at_beginning_of_month,"landlord").count
	  week_ll = @users.where("created_at >= ? AND status = ?", Date.today.at_beginning_of_week,"landlord").count
	  today_ll = @users.where("created_at >= ? AND status = ?", Date.today.at_beginning_of_day,"landlord").count
	  total_tenant = @users.where(:status => "tenant").count
	  year_tenant = @users.where("created_at >= ? AND status = ?", Date.today.at_beginning_of_year,"tenant").count
	  month_tenant = @users.where("created_at >= ? AND status = ?", Date.today.at_beginning_of_month,"tenant").count
	  week_tenant = @users.where("created_at >= ? AND status = ?", Date.today.at_beginning_of_week,"tenant").count
	  today_tenant = @users.where("created_at >= ? AND status = ?", Date.today.at_beginning_of_day,"tenant").count

	  respond_to do |format|
	    format.json { render :json => {properties: properties, tenants: tenants, landlords: landlords,total_ll:total_ll,year_ll:year_ll,month_ll:month_ll,week_ll:week_ll,today_ll:today_ll,total_ll:total_ll,total_tenant:total_tenant,year_tenant:year_tenant,month_tenant:month_tenant,week_tenant:week_tenant,today_tenant:today_tenant} }
      end
	end
end