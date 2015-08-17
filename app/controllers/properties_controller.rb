class PropertiesController < ApplicationController
  layout proc { false if request.xhr? }
  before_action :set_property, only: [:show, :edit, :update, :destroy]
  respond_to :html, :xml, :json, :mobile
  load_and_authorize_resource
  require "open-uri"
  require 'nokogiri'
  require 'rubygems'
  require 'zip'
  #protect_from_forgery except: [:disconnect_fb] 
  def index
    if current_user.status == "admin"
      @properties = []
      @properties << Property.where(status: "SSTC").order("created_at DESC")
      @properties << Property.where(status: "SSTCM").order("created_at DESC")
      @properties << Property.where(status: "Let Agreed").order("created_at DESC")
      # @properties << Property.where(sold: true, let: true).order("created_at DESC")
      @properties = @properties.flatten.uniq
      # @properties = Property.order("created_at DESC")
    elsif current_user.status == "landlord"
      @properties = Property.where(:user_id => current_user.id).order("created_at DESC")
    else
      @properties = Property.order("created_at DESC")
    end

    # if current_user.status == "landlord"
    #   @properties.each do |obj|
    #     if (obj.payment == true && (obj.validity - DateTime.now.in_time_zone("UTC")) < 0)
    #         obj.update_attributes(:payment => false,:visibility=>false,:validity=>nil)
    #     end
    #   end
    # end
    @users = User.all
    if current_user.status != "admin"
      @users.each do |obj|
        unless obj.validity == nil
          if (obj.payment == true && (obj.validity - DateTime.now.in_time_zone("UTC") < 0))
            obj.update_attributes(:payment => false,:validity=>nil)
          end
        end  
      end
    end

    respond_with(@properties)
    # respond_to do |format|
    #   format.html
    #   format.pdf do
    #     pdf = ReportPdf.new(@properties)
    #     send_data pdf.render, filename: 'report.pdf', type: 'application/pdf'
    #   end
    # end
  end

  def show
    respond_with(@property)
  end


  def new
    if (current_user.status == "landlord" && current_user.plan == "free" && current_user.properties.count >=3)
      redirect_to root_url, alert: "Please Upgrade Your Plan to Continue" 
    else  
      unless current_user.status == "tenant"
        @property = current_user.properties.new  
        respond_with(@property)
      end
    end    
  end

  def edit

  end

  def create
    @user = current_user
    @property = @user.properties.new(property_params)
    @property.category.downcase
    @property.name.downcase
    address =  params[:property][:address1]+" "+params[:property][:address2]+" "+params[:property][:address3]
    @a = Geokit::Geocoders::GoogleGeocoder.geocode "#{address}"
    @property.coordinates = "#{@a.lat},#{@a.lng}"
    @property.latitude = @a.lat
    @property.longitude = @a.lng
    @property.save
    @property.update_attributes(:payment=>true) if current_user.status == "admin"
    redirect_to "/properties" 
  end

  def update
    @property.update(property_params)
    if @property.let_changed?
      @property.l_date = Time.now
    end
    if @property.sold_changed?
      @property.s_date = Time.now
    end
    if @property.featured_changed?
      @property.r_date = Time.now
    end
    respond_with(@property)
  end

  def destroy
    @property.destroy
    respond_with(@property)
  end

  def search_property
    @search = Property.search(params[:q])
    @properties = @search.result
    @data =  current_user.search
    unless @data.nil?
      @category = @data.split("|")[0]
      @type = @data.split("|")[1]
      @price_less_than = @data.split("|")[2]
      @price_greater_than = @data.split("|")[3]
      @beds = @data.split("|")[4]
      @location = @data.split("|")[5]
    end

    if current_user.status == "tenant" && current_user.payment==false
      render :tenant_payment
    elsif current_user.status == "tenant" && current_user.payment==true
      render :tenant_search
    end
  end

  def tenant_search_result

    @request = request.host_with_port
    @abc = params[:q]
    category = @abc[:category_cont]
    type = @abc[:property_type]
    price_less_than = @abc[:price_lteq]
    price_greater_than = @abc[:price_gteq]
    beds = @abc[:beds_eq]
    location = @abc[:address1_or_address2_or_address3_cont]

    @user = current_user
    # @search = Property.search(params[:q])
    # @properties = @search.result
    # @properties = Property.where({visibility: true, approve: true})
    # if params[:q][:postcode_cont] != ""
    #   address2 = @properties.search(:address2_cont => params[:q][:postcode_cont])
    #   unless address2.result.empty?
    #     params[:q][:address2_cont] = params[:q][:postcode_cont]
    #   end

    #   address3 = @properties.search(:address3_cont => params[:q][:postcode_cont])
    #   unless address3.result.empty?
    #     params[:q][:address3_cont] = params[:q][:postcode_cont]
    #   end

    #   postcode = @properties.search(:postcode_cont => params[:q][:postcode_cont])
    #   if postcode.result.empty?
    #     params[:q].delete("postcode_cont")
    #   end
    # end

    # @search = @properties.search(params[:q])
    # @tasks = @search.result

    if params[:q][:beds_eq] == "Not Specified"
      params[:q].delete("beds_eq")
    end    

    if params[:q][:property_type] == "Not Specified"
      params[:q].delete("property_type")
      @search = Property.search(params[:q])
    else
      a=PropertyType.where(search: params[:q][:property_type])
      ids = []
      a.each do |o|
        ids << o.p_id
      end
      ids.each do |o|
        data = Property.where(property_type: o)
        @properties << data unless data.empty?
      end
      @search = @properties.search(params[:q])
    end

    @properties = @search.result
    @tasks = @properties.uniq

    @request = request.host_with_port
    # @abc = params[:q]
    # name = @abc[:name_cont]
    # category = @abc[:category_cont]
    # price_less_than = @abc[:price_lteq]
    # price_greater_than = @abc[:price_gteq]
    # beds = @abc[:beds_eq]
    # bath = @abc[:bath_eq]
    # @user.search = "#{name},#{category},#{price_less_than},#{price_greater_than},#{beds},#{bath}"
    @user.search = "#{category}|#{type}|#{price_less_than}|#{price_greater_than}|#{beds}|#{location}"
    @user.search.downcase
    @user.save

    render "/tasks/search_results"
    @properties = @properties.empty? ? Property.all.last(5) : @properties
    UserMailer.tenant_result_property(@user, @properties, @request).deliver
  end


  def approve
    @user = current_user
    @property = Property.find(params[:id])
    @status = params[:status]
    @property_id  = params[:id]
    if params[:status] == "Approve"
      @property.update_attributes(:approve=>true)
      @property.update_attributes(:approval_status=>"Approved")
      property_id = "SP"+@property.created_at.year.to_s.split(//).last(2).join()+@property.created_at.month.to_s.rjust(2,'0')+@property.id.to_s.rjust(4,'0')
      unless current_user.fb_token.nil?
        @api = Koala::Facebook::API.new(current_user.fb_token)
        @api.put_connections("sealproperties", "feed", {
          :message => "New Property:#{property_id} #{@property.name} has been Added.",
          :picture => @property.image1.url(:large),
          :link => "http://#{request.host_with_port}/properties_detail/#{@property.id}",
          :name => @property.name,
          :description => "#{@property.description}, Price: #{@property.price}",
          :location => @property.address3})
      end

      client = Twitter::REST::Client.new do |config|
        config.consumer_key        = "g6n3F8YmIIpK9NbpicuLlcDfl"
        config.consumer_secret     = "uCMstIIJUHbzb9kF1odq0zQTFrC0yII3T0Rm4xIeQgVcERiWM9"
        config.access_token        = "2964161159-uXFWcovn9C9gwSeneAmvGmATfC5mvfqdQgdGodm"
        config.access_token_secret = "i9Ws9DjyEmyC9fip50Prgo0L2exARNfhDz7IMbMq8L7M7"
      end  

      img=open(@property.image1.url(:large))
      if img.is_a?(StringIO)
        client.update("New Property:#{property_id} #{@property.name} has been Added. \nPrice:  #{@property.price} \nhttp://#{request.host_with_port}/properties_detail/#{@property.id}")
      else
        client.update_with_media("New Property:#{property_id} #{@property.name} has been Added.  \nPrice:  #{@property.price} \nhttp://#{request.host_with_port}/properties_detail/#{@property.id}", img)
      end  
      
    else
      @property.update_attributes(:approve=>false)
    end
    UserMailer.property_approval(@user, @property, @status).deliver
    respond_to do |format|
      format.js
    end
  end  

  def landlord_payment
    # Amount in cents
    # @amount = 500

    # customer = Stripe::Customer.create(
    #     :email => 'example@stripe.com',
    #     :card  => params[:stripeToken]
    # )

    # charge = Stripe::Charge.create(
    #     :customer    => customer.id,
    #     :amount      => @amount,
    #     :description => 'Rails Stripe customer',
    #     :currency    => 'usd'
    # )
  # Stripe.api_key = "sk_test_RsHCMpYllmYNshcj4p81bmfC"
  #     plan = "plan_10"
  #     binding.pry
  #     card_token = Stripe::Token.create( :card => { :name => params[:name_on_card], :number => params[:card_number], :exp_month => params[:exp_month], :exp_year => params[:exp_year], :cvc => params[:card_id] })
  #     customer_params = {:card => card_token[:id], :plan => plan, :email => @account.email}
  #     stripe_customer = Stripe::Customer.create(customer_params)

  rescue Stripe::CardError => e
    flash[:error] = e.message
  end

  # def tenant_payment
  #
  # end

  def confirm_landlord_payment
    begin
      Stripe.api_key = "sk_test_RsHCMpYllmYNshcj4p81bmfC"
      plan = "plan_10"
      card_token = Stripe::Token.create( :card => { :name => params[:name_on_card], :number => params[:card_number], :exp_month => params[:exp_month], :exp_year => params[:exp_year], :cvc => params[:card_id] })
      customer_params = {:card => card_token[:id], :plan => plan, :email => current_user.email}
      stripe_customer = Stripe::Customer.create(customer_params) 
      
      @property = Property.find(params[:id])
      old_validity = @property.validity || DateTime.now
      @property.update_attributes(:visibility=>true,:payment=>true, :validity=>(old_validity + 30.days))
      UserMailer.deliver_payment_method(@property).deliver
      @tenants = User.where(status: "tenant", payment: true)
      @request = request.host_with_port
      @tenants.each do |obj|
        @user = obj
        unless obj.search.nil?
          @result = obj.search.split(",")
          name = @result[0].empty? ? "false" : @result[0]
          category = @result[1].empty? ? "false" : @result[1]
          price_less_than = @result[2].empty? ? "false" : @result[2]
          price_greater_than = @result[3].empty? ? "false" : @result[3]
          beds = @result[4] #.empty? ? "false" : @result[4]
          bath = @result[5] #.empty? ? "false" : @result[5]
          if @property.name.include?(name) or @property.category.include?(category) or (price_less_than.to_i..price_greater_than.to_i).cover?(@property.price) or @property.beds.equal?(beds) or @property.bath.equal?(bath)
            UserMailer.property_search_match(@user, @property, @request).deliver
          end
        end  
      end
      redirect_to root_url, alert: "Payment confirmed. Thanks"
      rescue Stripe::CardError => e
      flash[:error] = e.message
    end
  end 

  def confirm_tenant_payment
    begin
      Stripe.api_key = "sk_test_RsHCMpYllmYNshcj4p81bmfC"
      plan = "plan_5"

      card_token = Stripe::Token.create( :card => { :name => params[:name_on_card], :number => params[:card_number], :exp_month => params[:exp_month], :exp_year => params[:exp_year], :cvc => params[:card_id] })
      customer_params = {:card => card_token[:id], :plan => plan, :email => current_user.email}
      stripe_customer = Stripe::Customer.create(customer_params) 
      
      current_user.update_attributes(:payment=>true)
      #UserMailer.deliver_payment_method(current_user)
      render :tenant_search
    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to search_form_path
    end
  end

  def tenant_search

  end

  def facebook_share
    @property = Property.find(params[:property_id])
    name =         @property.name
    page_link =    request.referer
    caption =     "#{@property.short_description} | #{@property.address3}"
    description =  @property.description || "N.A."
    picture_url =  "http://"+request.host_with_port+"/assets/seal_logo.png"

    url = "https://www.facebook.com/dialog/feed?app_id=362914167223991&"\
    "link=#{page_link}&"\
    "picture=#{picture_url}&"\
    "name=#{name}&"\
    "caption=#{caption}&"\
    "description=#{description}&"\
    "redirect_uri=http://#{request.host_with_port}/properties_detail/#{@property.id}&"\
    "display=page"

    redirect_to URI.encode(url)
  end  

  def connect_facebook
    @oauth = Koala::Facebook::OAuth.new("1621675821399010", "f249018913a98bc31d3df59a50658b17", "#{request.protocol}#{request.host}/get_fb_token/")
    redirect_to @oauth.url_for_oauth_code(:permissions => "manage_pages ,email,publish_actions")
  end

  def disconnect_fb
    current_user.update_attributes(:fb_token=>nil)
    redirect_to :back
    # render :json=>{:status=>true}.to_json
  end

  def get_fb_token
    if params[:code]
      @oauth = Koala::Facebook::OAuth.new("1621675821399010", "f249018913a98bc31d3df59a50658b17", "#{request.protocol}#{request.host}/get_fb_token/")
      session[:access_token] = @oauth.get_access_token(params[:code])
      @api = Koala::Facebook::API.new(session[:access_token])
      current_user.update_attributes(:fb_token=>session[:access_token])
      flash[:error] = "Connected with Facebook"
      redirect_to "/properties"
    end 
  end

  def advertisements
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
  end

  def ad
    @ad = []
    @ad = Advertisement.all
    @section = (@ad.count)/5
    # binding.pry
    # @section.times do |section|
    #   (1..5).each do |count|   (@ad.count)+1
    #     section = section * 5
    #     num = section + count
    #     @ad[num]
    #   end
    # end
  end

  def pdf_handle
    respond_to do |format|
      format.pdf do
      @properties = Property.find(params[:id])
      pdf = ReportPdf.new(@properties)
      send_data pdf.render, filename: 'report.pdf', type: 'application/pdf'
    end
    end
  end

  def brochure
    @properties = Property.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "brochure",
               page_size: "A3"      
      end
    end
    # respond_to do |format|
    #   format.pdf do
    #     @properties = Property.find(params[:id])
    #     pdf = Broucher.new(@properties)
    #     send_data pdf.render, filename: 'broucher.pdf', type: 'application/pdf'
    #   end
    # end
  end

  def brochure1
    @properties = Property.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "brochure",
               page_size: "A3",
               orientation: "Landscape"
      end
    end
  end

  def brochure2
    @properties = Property.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "brochure",
               page_size: "A4"
      end
    end
  end

   def approve_property
    @user = current_user
    @property = Property.find(params[:id])
    @status = params[:status]
    @property_id  = params[:id]
    if @status == "Click here for approval"
      @property.update_attributes(:approval_status=>"wait")
      @property.save
    end
    respond_to do |format|
      format.js
    end
  end

  def pay_plans
    if params[:plan] == "Pro"
      @pay = 99
    elsif params[:plan] == "Pro Plus"
      @pay = 30
    else
      @pay = 19.99
    end       
  end  

  def pay
    begin
      if current_user.status == "landlord"
        if params[:amount] == "99"
          plan = "Pro"
        elsif params[:amount] == "30"
          plan = "Pro Plus"
        else
          plan = "Basic Plus"    
        end
      else
        if params[:amount] == "99"
          plan = "Pro1"
        else
          plan = "Basic Plus1"    
        end
      end   
      Stripe.api_key = "sk_test_RsHCMpYllmYNshcj4p81bmfC"
      card_token = Stripe::Token.create( :card => { :name => params[:name_on_card], :number => params[:card_number], :exp_month => params[:exp_month], :exp_year => params[:exp_year], :cvc => params[:card_id] })
      customer_params = {:card => card_token[:id], :plan => plan, :email => current_user.email}
      stripe_customer = Stripe::Customer.create(customer_params) 
      old_validity = current_user.validity || DateTime.now
      current_user.update_attributes(:plan => plan, :validity=>(old_validity + 30.days), :payment => true)
      redirect_to root_url, notice: "Payment confirmed. Thanks"
      rescue Stripe::CardError => e
      flash[:error] = e.message
    end
  end  

  def my_plan

  end  

  def tenant_searching
    @data = []
    @properties = Property.all
    @tenants = User.where(:status => "tenant")
    @agents = Agent.all
    @news = News.all
    @properties.each do |p|
      @tenants.each do |t|
        unless t.search.nil?
          @string = t.search
          @words = @string.split(/\W+/)
          @category = @words[1]
          @price_l = @words[2]
          @price_g = @words[3]
          @beds = @words[4]
          @bath = @words[5]
          if p.category.include?(@category) && (@price_l.to_i..@price_g.to_i).cover?(p.price) && p.beds.equal?(@beds.to_i) && p.bath.equal?(@bath.to_i)
            @data << t
          end 
        end 
      end
    end    
  end  

  def blm
    @data = Property.where(:visibility=>true,:approve=>true, :otm=>true)
    render layout: false
  end

  def test_blm
    @data = Property.where(:visibility=>true,:approve=>true, :otm=>true)
    render layout: false
  end

  def download_blm
    @data = Property.where(:visibility=>true,:approve=>true, :otm=>true)
    remote_data = render_to_string "download_blm", :layout => false
    remote_data = remote_data.gsub("<pre>","")
    remote_data = remote_data.gsub("</pre>","")
    remote_data = remote_data.gsub("&lt;","<")
    remote_data = remote_data.gsub("&gt;",">")
    remote_data = remote_data.gsub("&quot;","'")
    send_data( remote_data, :filename => "my_file.blm" )

    # remote_data = Nokogiri::HTML(open("http://www.sealproperties.co.uk/blm"))
    # remote_data = remote_data.css("body").text
    # # my_local_file = open("my.txt", "w") 

    # # my_local_file.write(remote_data)
    # # my_local_file.close
    # # remote_data = remote_data.gsub("<pre>","")
    # # remote_data = remote_data.gsub("</pre>","")
    # # remote_data = remote_data.gsub("&lt;","<")
    # # remote_data = remote_data.gsub("&gt;",">")
    # # remote_data = remote_data.gsub("&quot;","'")
    # send_data( remote_data, :filename => "my_file" )
  end

  def zip_blm
    @data = Property.where(:visibility=>true,:approve=>true, :otm=>true)
    t = Tempfile.new("my-temp-filename-#{Time.now}")
    Zip::OutputStream.open(t.path) do |z|
      @data.each_with_index do |item,i|
        sp = "39545_SP"+item.created_at.year.to_s.split(//).last(2).join()+item.created_at.month.to_s.rjust(2,'0')+item.id.to_s.rjust(4,'0')
        (0..9).each do |n|
          if !item.send("image#{n+1}").url.nil? && !item.send("image#{n+1}").path.nil?
            puts item.send("image#{n+1}").path
            z.put_next_entry(sp+"_IMG_"+n.to_s.rjust(2,'0')+"."+item.send("image#{n+1}").path.split(".").last.downcase)
            url1 = item.send("image#{n+1}").url(:large)
            url1_data = open(url1.gsub('https','http')).read
            z.print url1_data
          end
        end
        # z.put_next_entry("#{sp}_DOC_00.pdf")
        # z.print open("http://www.sealproperties.co.uk/broucher.pdf?id="+item.id.to_s).read
      end
      z.put_next_entry("coming_soon.jpg")
      z.print  File.open("#{Rails.root}/app/assets/images/default_images/no.jpg").read
      d=DateTime.now
      seq = "01"
      f_name = "39545_"+d.year.to_s+d.month.to_s.rjust(2,'0')+d.day.to_s+seq
      z.put_next_entry("#{f_name}.blm")
      remote_data = render_to_string "download_blm", :layout => false
      remote_data = remote_data.gsub("<pre>","")
      remote_data = remote_data.gsub("</pre>","")
      remote_data = remote_data.gsub("&lt;","<")
      remote_data = remote_data.gsub("&gt;",">")
      remote_data = remote_data.gsub("&quot;","'")
      z.print remote_data
    end
    send_file t.path, :type => 'application/zip',:disposition => 'attachment',
    :filename => "39545.zip"
    t.close
    # render :nothing=> true
  end

  def upload_blm
    Thread.new do
    @data = Property.where(:visibility=>true,:approve=>true, :otm=>true)
    t = Tempfile.new("39545")
    Zip::OutputStream.open(t.path) do |z|
      @data.each_with_index do |item,i|
        sp = "39545_SP"+item.created_at.year.to_s.split(//).last(2).join()+item.created_at.month.to_s.rjust(2,'0')+item.id.to_s.rjust(4,'0')
        (0..9).each do |n|
          if !item.send("image#{n+1}").url.nil? && !item.send("image#{n+1}").path.nil?
            puts item.send("image#{n+1}").path
            z.put_next_entry(sp+"_IMG_"+n.to_s.rjust(2,'0')+"."+item.send("image#{n+1}").path.split(".").last.downcase)
            url1 = item.send("image#{n+1}").url(:large)
            url1_data = open(url1.gsub('https','http')).read
            z.print url1_data
          end
        end
        # z.put_next_entry("#{sp}_DOC_00.pdf")
        # z.print open("http://www.sealproperties.co.uk/broucher.pdf?id="+item.id.to_s).read
      end
      z.put_next_entry("coming_soon.jpg")
      z.print  File.open("#{Rails.root}/app/assets/images/default_images/no.jpg").read
      d=DateTime.now
      seq = "01"
      f_name = "39545_"+d.year.to_s+d.month.to_s.rjust(2,'0')+d.day.to_s+seq
      z.put_next_entry("#{f_name}.blm")
      remote_data = render_to_string "download_blm", :layout => false
      remote_data = remote_data.gsub("<pre>","")
      remote_data = remote_data.gsub("</pre>","")
      remote_data = remote_data.gsub("&lt;","<")
      remote_data = remote_data.gsub("&gt;",">")
      remote_data = remote_data.gsub("&quot;","'")
      z.print remote_data
    end
    require 'net/ftp'
    Net::FTP.open('feeds.agentsmutual.co.uk', 'sealproperties', 'Pwx85N8zAK8wHC5') do |ftp|
      ftp.passive = true
      ftp.chdir("/live/upload")
      ftp.putbinaryfile(t.path,"39545.zip")
    end

    #send_file t.path, :type => 'application/zip',:disposition => 'attachment',
    #:filename => "39545.zip"
    t.close
  end
  redirect_to root_url, notice: "Uploading is start...."
     # render :nothing=> true
  end

  def upload_pdf
    Thread.new do
    @property = Property.find(params[:id])
    sp = "sp"+@property.created_at.year.to_s.split(//).last(2).join()+@property.created_at.month.to_s.rjust(2,'0')+@property.id.to_s.rjust(4,'0')
    data = open("http://www.sealproperties.co.uk/brochure.pdf?id="+params[:id])
    puts data
    service = S3::Service.new(:access_key_id => ENV['AWS_ACCESS_KEY'],:secret_access_key => ENV['AWS_SECRET_KEY'])
    bucket = service.buckets.find("sealpropertiesus")
    object = bucket.objects.build("brochure_"+sp+".pdf")
    puts object
    object.content = data
    object.save
    @property.brochure_link = "http://sealpropertiesus.s3.amazonaws.com/brochure_"+sp+".pdf"
    @property.save
    end
    render :json => {:status => "ok"}
  end

  def delete_pdf
    @property = Property.find(params[:id])
    sp = "sp"+@property.created_at.year.to_s.split(//).last(2).join()+@property.created_at.month.to_s.rjust(2,'0')+@property.id.to_s.rjust(4,'0')
    service = S3::Service.new(:access_key_id => ENV['AWS_ACCESS_KEY'],:secret_access_key => ENV['AWS_SECRET_KEY'])
    bucket = service.buckets.find("sealpropertiesus")
    object = bucket.objects.find("brochure_"+sp+".pdf")
    if object
      object.destroy
      @property.brochure_link = nil
      @property.save
    end 
    render :json => {:status => "ok"}
  end

  def search_criteria
    @data = PropertyType.where(search: params[:search])
  end

  private
    def set_property
      @property = Property.friendly.find(params[:id])
    end

    def property_params
      params.require(:property).permit(:name, :address1, :address2, :address3, :postcode, :bath, :beds, :parking, :category, :image1, :image2, :image3, :image4, :image5, :image6, :image7, :image8, :image9, :image10, :description, :date, :visibility, :price, :let, :sold, :featured, :approved, :payment, :user_id, :agent_id, :coordinates, :latitude, :longitude,:gas_ch,:glazing,:parking_status,:car,:short_description,:tag_line,:dg,:garden,:seal_approved,:property_type,:pets,:ensuite,:town,:status,:postcode1,:qualifier,:summary,:furnished,:feature1,:feature2,:epc,:brochure_link,:let_type_id,:let_furn_id,:let_date_available,:otm)
    end

end