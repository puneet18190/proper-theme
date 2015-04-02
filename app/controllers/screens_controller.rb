class ScreensController < ApplicationController
	require 'json'
	require 'pat'
	require 'rqrcode_png' 
	respond_to :html, :xml, :json
	layout proc { false if request.xhr? }
	protect_from_forgery :except => "update_screen_status"
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

	def phones
		# binding.pry
		@data = DirectoryEntry.all.select(:Name, :Telephone)
		# arr = [:YealinkIPPhoneDirectory => []]
		# @data.each do |obj| 
		# 	arr[0][:YealinkIPPhoneDirectory ].push(DirectoryEntry: {:Name => obj.Name, :Telephone=> obj.Telephone })
		# end
		# arr = {:YealinkIPPhoneDirectory => 
		# 	{:DirectoryEntry => {:Name=>"dsd",:Telephone=>"87878"}},
		# 	{:DirectoryEntry => {:Name=>"dsd",:Telephone=>"878sa"}}
		# }
		# builder = Nokogiri::XML::Builder.new do |xml|
		#   xml.YealinkIPPhoneDirectory {
		#     @data.each do |ob|
		#       xml.DirectoryEntry {
		#         xml.Name ob.Name
		#         xml.Telephone ob.Telephone
		#       }
		#     end
		#   }
		# end
		# @data = builder.to_xml
		# binding.pry
		# respond_with(@data)
	end	

	def uploadfile
		@data = Provision.create(:name => params[:filename], :url => params[:url])
	    respond_to do |format|
	      format.js
	    end
	  end
end