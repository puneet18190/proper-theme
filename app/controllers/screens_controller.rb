class ScreensController < ApplicationController
	require 'json'
	require 'pat'
	require 'rqrcode_png' 
	require 's3'
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

	def newest
		@properties = Property.where(:visibility=>true).last(5)
		render '/screens/newest/newest', :layout => "screen_layout"
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

	def featured_properties
		@properties = Property.where(:featured=>true).last(5)
		render '/screens/oldest/featured', :layout => "screen_layout"
	end	

	def random_properties
		@properties = Property.where(:visibility=>true).sample(5)
		render '/screens/oldest/random', :layout => "screen_layout"
	end	
	def cycle
		@properties = Property.where(:payment=>true, :visibility => true)
		render '/screens/oldest/cycle', :layout => "screen_layout"
	end	

	def oldest
		@properties = Property.where(:payment=>true,:visibility=>true).first(10)
		render '/screens/oldest/oldest', :layout => "screen_layout"
	end	

	def oldest_properties_detail
		@data = Property.find(params[:property_id])
		@postcode = Pat.get(@data.postcode.to_s)
		@datapat = JSON.parse(@postcode.body)
		url = "http://#{request.host_with_port}/properties_detail/#{@data.id}"
		@qr = RQRCode::QRCode.new(url,:size => 10).to_img.resize(200, 200).to_data_url
		render '/screens/oldest/oldest_properties_detail'
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
			redirect_to root_url, alert: "IP: #{request.ip} is not Authorized." 
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
			redirect_to root_url, alert: "IP: #{request.ip} is not Authorized." 
		end	
	end
	
	def tenants
		if request.ip == "82.68.0.86" || request.ip == "82.68.180.14" 
			@data = User.all.where("status = ?", "tenant")
		else
			redirect_to root_url, alert: "IP: #{request.ip} is not Authorized." 
		end	
	end	

	def mobiles
		if request.ip == "82.68.0.86" || request.ip == "82.68.180.14" 
			@data = Mobile.all.select(:name, :telephone)
		else
			redirect_to root_url, alert: "IP: #{request.ip} is not Authorized." 
		end			
	end
	def services
		if request.ip == "82.68.0.86" || request.ip == "82.68.180.14" 
			@data = Service.all.select(:name, :telephone)
		else
			redirect_to root_url, alert: "IP: #{request.ip} is not Authorized." 
		end					
	end	

	def delete_file_from_s3
		service = S3::Service.new(:access_key_id => "AKIAI42ZRYRPLOREEEDQ",:secret_access_key => "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")
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

			service = S3::Service.new(:access_key_id => "AKIAI42ZRYRPLOREEEDQ",:secret_access_key => "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")
			bucket = service.buckets.find("sealpropertiesus")
			a=DateTime.now
			a=a.year.to_s+a.month.to_s.rjust(2,'0')+a.day.to_s.rjust(2,'0')+a.hour.to_s+a.minute.to_s+a.second.to_s
			object = bucket.objects.build(a+"file#{i}.odt")
			object.content = report.generate()
			object.save
			@data.mail_merge_items.create(:filename => a+"file#{i}.odt", :url=>"https://sealpropertiesus.s3.amazonaws.com/"+a+"file#{i}.odt",:m_type=>"item")			    
		end	
		respond_to do |format|
	      format.js
	    end
	end	
end