class PropertiesController < ApplicationController
  layout proc { false if request.xhr? }
  before_action :set_property, only: [:show, :edit, :update, :destroy, :change]
  respond_to :html, :xml, :json, :mobile
  load_and_authorize_resource
  require "open-uri"
  require 'nokogiri'
  require 'rubygems'
  require 'zip'

  def index
    if current_user.status == "admin"
      @properties = []
      @data = Property.where.not("approval_status = ?", "none")
      @properties << @data.where.not("status = ? OR status = ? OR status = ?", "SSTC","SSTCM","Let Agreed" ).order("created_at DESC").includes(:user).includes(:agent)
      @properties << @data.where("status = ? OR status = ? OR status = ?", "SSTC","SSTCM","Let Agreed" ).order("created_at DESC").includes(:user).includes(:agent)
      @properties = @properties.flatten.uniq
    elsif current_user.status == "landlord"
      @properties = Property.where(:user_id => current_user.id).order("created_at DESC").includes(:property_changes).includes(:user)
    else
      @properties = Property.order("created_at DESC")
    end

    respond_with(@properties)
  end

  def show
    respond_with(@property)
  end

  def new
    if current_user.status == "landlord" && (current_user.plan == "basic" || current_user.plan == "free")  && current_user.properties.count >= 3
      session[:plan] = true
      redirect_to "/properties"
    else
      unless current_user.status == "tenant"
        @property = current_user.properties.new
        @user = @property.build_user
        @tenant = @property.tenants.build  #@property.build_tenant
        @key = @property.build_key
        @vetting = @property.build_vetting
        @property_info = @property.build_property_info
        @guarantor = @property.build_guarantor
        @right_to_rent = @property.build_right_to_rent
        @tenancy_term = @property.build_tenancy_term
        @pet_detail = @property.build_pet_detail
        @property_document = @property.property_documents.new
        respond_with(@property)
      end
    end    
  end

  def edit
    if current_user.status == "tenant"
      redirect_to root_url, alert: "You are not authorized."
    elsif current_user.status == "landlord" && Property.where(slug: params[:id]).first.user.id != current_user.id
      redirect_to root_url, alert: "You are not authorized."
    elsif current_user.status == "admin"
      @user = (@property.user_id == current_user.id) ? @property.build_user : @property.user
      # @tenant = @property.tenant.blank? ? @property.build_tenant : @property.tenant
      # @tenant = TenantProperty.where(property_id: )
      ids =TenantProperty.where(property_id: Property.where(slug: params[:id])[0].id).map(&:tenant_id)
      @tenant = User.where(status: "tenant", id: ids)
      @tenant_count = User.where(status: "tenant", id: ids).where(po: false).count
      @po_count = User.where(status: "tenant", id: ids).where(po: true).count
      if @tenant.blank?
        @tenant = @property.tenants.build 
        @no_tenant=true
      end
      @key = @property.key.nil? ? @property.build_key : @property.key
      @vetting = @property.vetting.nil? ? @property.build_vetting : @property.vetting
      @property_info = @property.property_info.blank? ? @property.build_property_info : @property.property_info
      @guarantor = @property.guarantor.blank? ? @property.build_guarantor : @property.guarantor
      @right_to_rent = @property.right_to_rent.blank? ? @property.build_right_to_rent : @property.right_to_rent
      @tenancy_term = @property.tenancy_term.nil? ? @property.build_tenancy_term : @property.tenancy_term
      @pet_detail = @property.pet_detail.nil? ? @property.build_pet_detail : @property.pet_detail
      @tenancy_history = @property.tenant_histroys
      @documents = @property.property_documents
      @property_document = @property.property_documents.new
    end
  end

  def change
    @property = @property.property_changes.last
  end

  def create
    params[:property][:epc] = upload_document(params[:property][:epc], "epc", "", "create") unless params[:property][:epc].nil?
    params[:property][:cp12] = upload_document(params[:property][:cp12], "cp12", "", "create") unless params[:property][:cp12].nil?
    params[:property][:esc] = upload_document(params[:property][:esc], "esc", "", "create") unless params[:property][:esc].nil?
    params[:property][:vetting_attributes][:vetting_doc] = upload_document(params[:property][:vetting_attributes][:vetting_doc], "vetting_doc", "", "create") unless params[:property][:vetting_attributes][:vetting_doc].nil?

    params[:property][:price] = params[:property][:price].scan(/\d+/).first.to_i

    params[:property][:user_id] = set_landlord_tenant(params[:property][:user][:email], "landlord", "create")
    # params[:property][:tenant_id] = set_landlord_tenant(params[:property][:tenant][:email], "tenant", "create")
    key_data = params[:property][:key]
    params[:property].delete('user')
    params[:property].delete('tenant')
    params[:property].delete('key')

    params[:property][:property_document][:url] = upload_property_doc(params[:property][:property_document]) unless params[:property][:property_document][:property_doc].nil?
    @property = Property.new(property_params)
    @property.category.downcase
    @property.name.downcase
    address =  params[:property][:address1]+" "+params[:property][:address2]+" "+params[:property][:address3]
    @a = Geokit::Geocoders::GoogleGeocoder.geocode "#{address}"
    @property.coordinates = "#{@a.lat},#{@a.lng}"
    @property.latitude = @a.lat
    @property.longitude = @a.lng
    @property.agent_id = Agent.where(name: "Landlord").first.id if current_user.status == "landlord"
    @property.save
    Key.where(key_number: key_data["key_number"]).first.update_attributes(key_status: key_data["key_status"], property_id: @property.id) unless key_data["key_number"].blank?
    @property.save_multiple_tenants(params[:property][:tenants_attributes], "create")
    @property.add_key(params[:property][:key_num], key_data["key_number"], "create")

    @property.update_attributes(:payment=>true, :property_create_user => "admin") if current_user.status == "admin"
    
    prop_doc = params[:property][:property_document]
    @property.property_documents.create(name: prop_doc["name"], description: prop_doc["description"], url: prop_doc["url"]) unless prop_doc["url"].blank?
    
    Blm.where(name: "onthemarket").first.update_attributes(count: 0)
    if current_user.status == "landlord"
      @property.update_attributes(:property_create_user => "landlord")
      redirect_to "/properties", notice: "Once you have finished editing your property, please submit it for approval."
    else
      redirect_to "/properties", notice: "Property created successfully."
    end
  end

  def update
    begin
    params[:property][:epc] = upload_document(params[:property][:epc], "epc", @property, "update") unless params[:property][:epc].nil?
    params[:property][:cp12] = upload_document(params[:property][:cp12], "cp12", @property, "update") unless params[:property][:cp12].nil?
    params[:property][:esc] = upload_document(params[:property][:esc], "esc", @property, "update") unless params[:property][:esc].nil?
    params[:property][:vetting_attributes][:vetting_doc] = upload_document(params[:property][:vetting_attributes][:vetting_doc], "vetting_doc", @property, "update") unless params[:property][:vetting_attributes][:vetting_doc].nil?

    if current_user.status == "landlord"
      ['image1','image2','image3','image4','image5','image6','image7','image8','image9','image10'].each do |obj|
        if params[:property].has_key?(obj)
          @property.update_attributes(obj.to_sym => params[:property][obj.to_sym]) 
          params[:property].delete(obj)
        end
      end
      params[:property][:price] = params[:property][:price].scan(/\d+/).first.to_i
      @property.property_changes.find_or_create_by(property_changes_params)
      @property.update_attributes(approval_status: "none")
      redirect_to "/properties", notice: "Once you have finished editing your property, please submit it for approval."
    else

      params[:property][:user_id] = set_landlord_tenant(params[:property][:user][:email], "landlord", "update")
      # params[:property][:tenant_id] = set_landlord_tenant(params[:property][:tenant][:email], "tenant", "update")
      params[:property].delete('user')
      # params[:property].delete('tenant')

      params[:property][:let_agreed_date] = DateTime.now if @property.status=="Available" && params[:property][:status] == "Let Agreed"
      params[:property][:sold_date] = DateTime.now if @property.stage!="Complete" && params[:property][:stage] == "Complete"

      key_data = params[:property][:key]
      params[:property].delete('key')

      params[:property][:property_document][:url] = upload_property_doc(params[:property][:property_document]) unless params[:property][:property_document][:property_doc].nil?
      prop_doc = params[:property][:property_document]
      @property.property_documents.create(name: prop_doc["name"], description: prop_doc["description"], url: prop_doc["url"]) unless prop_doc["url"].blank?
      @property.update_attributes(property_params)
      @property.add_key(params[:property][:key_num], key_data["key_number"], "update")  
      if params[:property][:tenant].blank? && params[:property][:tenants_attributes].blank?
        TenantProperty.where(property_id: @property.id).delete_all
      elsif !params[:property][:tenant].blank?
        @property.save_multiple_tenants(params[:property][:tenant], "update")
      else
        @property.save_multiple_tenants(params[:property][:tenants_attributes], "create")
      end
      if @property.let_changed?
        @property.l_date = Time.now
      end
      if @property.sold_changed?
        @property.s_date = Time.now
      end
      if @property.featured_changed?
        @property.r_date = Time.now
      end

      if key_data["key_number"].blank?
        Key.where(key_number: @property.key.key_number).first.update_attributes(key_status: key_data["key_status"], property_id: nil) unless @property.key.blank?
      else
        Key.where(key_number: key_data["key_number"]).first.update_attributes(key_status: key_data["key_status"], property_id: @property.id)
      end
      redirect_to :back, notice: "Property updated successfully."
    end
    rescue Exception => e
      redirect_to "/properties", alert: e.message
    end
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

    render :tenant_search
  end

  def tenant_search_result
    @request = request.host_with_port
    @abc = params[:q]
    category = @abc[:category_cont]
    type = @abc[:property_type]
    price_less_than = @abc[:price_lteq]
    price_greater_than = @abc[:price_gteq]
    beds = @abc[:beds_eq]
    location = @abc[:address1_or_address2_or_address3_or_town_cont]

    @user = current_user.status == "admin" ? User.find(params[:q][:user_id].to_i) : current_user
    @all_property = Property.where({visibility: true, approval_status: "approved"})

    if params[:q][:beds_eq] == "Not Specified"
      params[:q].delete("beds_eq")
    end    

    if params[:q][:property_type] == "Not Specified"
      params[:q].delete("property_type")
      @search = @all_property.search(params[:q])
    else
      a=PropertyType.where(search: params[:q][:property_type])
      ids = []
      a.each do |o|
        ids << o.p_id.to_s
      end
      @properties = @all_property.where(property_type: ids)
      @properties = @all_property if @properties.blank?
      @search = @properties.search(params[:q])
    end

    @properties = @search.result
    @tasks = @properties.uniq

    @request = request.host_with_port
    @user.search = "#{category}|#{type}|#{price_less_than}|#{price_greater_than}|#{beds}|#{location}"
    @user.search.downcase
    @user.save

    render "/tasks/search_results"
    @properties = @properties.empty? ? @all_property.all.last(5) : @properties
    UserMailer.tenant_result_property(@user, @properties, @request).deliver unless request.referer.split('/').last == "edit"
  end

  def approve
    @user = current_user
    @property = Property.find(params[:id])
    changes = @property.property_changes.last
    @status = params[:status]
    @property_id  = params[:id]
    if params[:status] == "approved"
      if !@property.property_changes.empty? 
        ['name','address1','address2','address3','postcode','postcode1','property_type','beds','bath','parking_status','car','ensuite','let_type_id','let_furn_id','gas_ch','garden','dg','pets','feature1','feature2','category','status','price','tag_line','summary','short_description','description','created_at','updated_at','town','image1','image2','image3','image4','image5','image6','image7','image8','image9','image10','epc'].each do |obj|
          @property.update_attributes(obj.to_sym => changes.send(obj)) if @property.send(obj) != changes.send(obj)
        end
        @property.property_changes.delete_all
      end
      @property.update_attributes(:approval_status=>"approved")
      # property_id = "SP"+@property.created_at.year.to_s.split(//).last(2).join()+@property.created_at.month.to_s.rjust(2,'0')+@property.id.to_s.rjust(4,'0')
      # unless current_user.fb_token.nil?
      #   @api = Koala::Facebook::API.new(current_user.fb_token)
      #   @api.put_connections("sealproperties", "feed", {
      #     :message => "New Property:#{property_id} #{@property.name} has been Added.",
      #     :picture => @property.image1.url(:large),
      #     :link => "http://#{request.host_with_port}/properties_detail/#{@property.id}",
      #     :name => @property.name,
      #     :description => "#{@property.description}, Price: #{@property.price}",
      #     :location => @property.address3})
      # end

      # client = Twitter::REST::Client.new do |config|
      #   config.consumer_key        = "g6n3F8YmIIpK9NbpicuLlcDfl"
      #   config.consumer_secret     = "uCMstIIJUHbzb9kF1odq0zQTFrC0yII3T0Rm4xIeQgVcERiWM9"
      #   config.access_token        = "2964161159-uXFWcovn9C9gwSeneAmvGmATfC5mvfqdQgdGodm"
      #   config.access_token_secret = "i9Ws9DjyEmyC9fip50Prgo0L2exARNfhDz7IMbMq8L7M7"
      # end  

      # img=open(@property.image1.url(:large))
      # if img.is_a?(StringIO)
      #   client.update("New Property:#{property_id} #{@property.name} has been Added. \nPrice:  #{@property.price} \nhttp://#{request.host_with_port}/properties_detail/#{@property.id}")
      # else
      #   client.update_with_media("New Property:#{property_id} #{@property.name} has been Added.  \nPrice:  #{@property.price} \nhttp://#{request.host_with_port}/properties_detail/#{@property.id}", img)
      # end  
      
    else
      @property.update_attributes(:approval_status=>"unapprove")
      @property.property_changes.delete_all
    end
    # UserMailer.property_approval(@user, @property, @status).deliver
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
          beds = @result[4]
          bath = @result[5]
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
    @search = Property.search(params[:q])
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
    @property = Property.find(params[:id])
    @status = params[:status]
    @property_id = params[:id]
    if @status == "waiting"
      @property.update_attributes(:approval_status=>"waiting")
      @property.save
    end
    respond_to do |format|
      format.js
    end
  end

  def pay_plans
    if current_user.status == "landlord"
      if params[:plan] == "pro"
        @pay = 199
      elsif params[:plan] == "pro_plus"
        @pay = 30
      elsif params[:plan] == "Basic Plus"
        @pay = 19.99
      else
        @pay = 0
      end
    else
      if params[:plan] == "pro"
        @pay = 199
      elsif params[:plan] == "basic_plus"
        @pay = 19.99
      else
        @pay = 0
      end
    end       
  end  

  def pay
    begin
      if current_user.status == "landlord"
        if params[:amount] == "199"
          plan = "pro"
        elsif params[:amount] == "30"
          plan = "pro_plus"
        elsif params[:amount] == "19.99"
          plan = "basic_plus"
        else
          plan = "free"    
        end
      else
        if params[:amount] == "199"
          plan = "pro"
        elsif params[:amount] == "19.99"
          plan = "basic_plus"
        else
          plan = "free"    
        end
      end   
      Stripe.api_key = "sk_test_RsHCMpYllmYNshcj4p81bmfC"
      card_token = Stripe::Token.create( :card => { :name => params[:name_on_card], :number => params[:card_number], :exp_month => params[:exp_month], :exp_year => params[:exp_year], :cvc => params[:card_id] })
      customer_params = {:card => card_token[:id], :plan => plan, :email => current_user.email}
      stripe_customer = Stripe::Customer.create(customer_params) 
      # old_validity = current_user.validity || DateTime.now
      old_validity = (current_user.validity.to_i < DateTime.now.to_i) ? DateTime.now : current_user.validity
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
    @agents = Agent.all.first 2
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
    @data = Property.where(:approval_status=>"approved", :otm=>true)
    render layout: false
  end

  def blm1
    @data = Property.where(:approval_status=>"approved", :mouse_price=>true)
    render layout: false
  end

  def blm2
    @data = Property.where(:approval_status=>"approved", :dss_move=>true)
    render layout: false
  end

  def blm3
    @data = Property.where(:approval_status=>"approved", :nethouse=>true)
    render layout: false
  end

  def blm4
    @data = Property.where(:approval_status=>"approved", :home=>true)
    render layout: false
  end

  def blm5
    @data = Property.where(:approval_status=>"approved", :zoopla=>true)
    render layout: false
  end

  def test_blm
    @data = Property.where(:approval_status=>"approved", :otm=>true)
    render layout: false
  end

  def download_blm
    @data = Property.where(:approval_status=>"approved", :otm=>true)
    remote_data = render_to_string "download_blm", :layout => false
    remote_data = remote_data.gsub("<pre>","")
    remote_data = remote_data.gsub("</pre>","")
    remote_data = remote_data.gsub("&lt;","<")
    remote_data = remote_data.gsub("&gt;",">")
    remote_data = remote_data.gsub("&quot;","'")
    send_data( remote_data, :filename => "my_file.blm" )
  end

  def zip_blm
    @data = Property.where(:approval_status=>"approved", :otm=>true)
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
        z.put_next_entry("#{sp}_DOC_00.pdf")
        z.print open("http://www.sealproperties.co.uk/brochure.pdf?id="+item.id.to_s).read
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
  end

  def upload_blm
    Thread.new do
      @data = Property.where(:approval_status=>"approved", :otm=>true)
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
      t.close
    end
    redirect_to root_url, notice: "Onthemarket Uploading is start...."
  end

  def upload_blm_mouseprice
    Thread.new do
      @data = Property.where(:approval_status=>"approved", :mouse_price=>true)
      t = Tempfile.new("SP39545")
      Zip::OutputStream.open(t.path) do |z|
        @data.each_with_index do |item,i|
          sp = "SP39545_SP"+item.created_at.year.to_s.split(//).last(2).join()+item.created_at.month.to_s.rjust(2,'0')+item.id.to_s.rjust(4,'0')
          (0..9).each do |n|
            if !item.send("image#{n+1}").url.nil? && !item.send("image#{n+1}").path.nil?
              puts item.send("image#{n+1}").path
              z.put_next_entry(sp+"_IMG_"+n.to_s.rjust(2,'0')+"."+item.send("image#{n+1}").path.split(".").last.downcase)
              url1 = item.send("image#{n+1}").url(:large)
              url1_data = open(url1.gsub('https','http')).read
              z.print url1_data
            end
          end
          z.put_next_entry("#{sp}_DOC_00.pdf")
          z.print open("http://www.sealproperties.co.uk/brochure.pdf?id="+item.id.to_s).read
        end
        z.put_next_entry("coming_soon.jpg")
        z.print  File.open("#{Rails.root}/app/assets/images/default_images/no.jpg").read
        d=DateTime.now
        seq = "01"
        f_name = "39545_"+d.year.to_s+d.month.to_s.rjust(2,'0')+d.day.to_s+d.hour.to_s.rjust(2,'0')+d.minute.to_s.rjust(2,'0')
        z.put_next_entry("#{f_name}.blm")
        ac = ApplicationController.new()
        remote_data = ac.render_to_string "properties/download_blm1", :locals => {:@data => @data}, :layout=>false
        remote_data = remote_data.gsub("<pre>","")
        remote_data = remote_data.gsub("</pre>","")
        remote_data = remote_data.gsub("&lt;","<")
        remote_data = remote_data.gsub("&gt;",">")
        remote_data = remote_data.gsub("&quot;","'")
        z.print remote_data
      end
      require 'net/ftp'
      # Net::FTP.open('feeds.agentsmutual.co.uk', 'sealproperties', 'Pwx85N8zAK8wHC5') do |ftp|
      #   ftp.passive = true
      #   ftp.chdir("/live/upload")
      #   ftp.putbinaryfile(t.path,"39545.zip")
      # end
      d=DateTime.now
      f_name = "39545_"+d.year.to_s+d.month.to_s.rjust(2,'0')+d.day.to_s+d.hour.to_s.rjust(2,'0')+d.minute.to_s.rjust(2,'0')
      Net::FTP.open('mouseprice.net', 'SealProp', 'SealProp77') do |ftp|
        ftp.passive = true
        # ftp.chdir("/")                
        ftp.putbinaryfile(t.path,"SP#{f_name}.zip")
      end
      t.close
    end
    redirect_to root_url, notice: "MousePrice Uploading is start...."
  end

  def upload_blm_dssmove
    Thread.new do
      @data = Property.where(:approval_status=>"approved", :dss_move=>true)
      t = Tempfile.new("8266149499")
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
          z.put_next_entry("#{sp}_DOC_00.pdf")
          z.print open("http://www.sealproperties.co.uk/brochure.pdf?id="+item.id.to_s).read
        end
        z.put_next_entry("coming_soon.jpg")
        z.print  File.open("#{Rails.root}/app/assets/images/default_images/no.jpg").read
        d=DateTime.now
        seq = "01"
        f_name = "8266149499_"+d.year.to_s+d.month.to_s.rjust(2,'0')+d.day.to_s+seq
        z.put_next_entry("#{f_name}.blm")
        ac = ApplicationController.new()
        remote_data = ac.render_to_string "properties/download_blm2", :locals => {:@data => @data}, :layout=>false
        remote_data = remote_data.gsub("<pre>","")
        remote_data = remote_data.gsub("</pre>","")
        remote_data = remote_data.gsub("&lt;","<")
        remote_data = remote_data.gsub("&gt;",">")
        remote_data = remote_data.gsub("&quot;","'")
        z.print remote_data
      end
      require 'net/ftp'
      Net::FTP.open('80.175.35.42', 'ftpdss_user', 'gmBbqQ12A8a9TrReaE17') do |ftp|
        ftp.passive = true
        ftp.putbinaryfile(t.path,"8266149499.zip")
      end
      t.close
    end
    redirect_to root_url, notice: "DSSMove Uploading is start...."
  end

  def upload_blm_zoopla
    Thread.new do
      @data = Property.where(:approval_status=>"approved", :zoopla=>true)
      t = Tempfile.new("70273")
      Zip::OutputStream.open(t.path) do |z|
        @data.each_with_index do |item,i|
          sp = "70273_SP"+item.created_at.year.to_s.split(//).last(2).join()+item.created_at.month.to_s.rjust(2,'0')+item.id.to_s.rjust(4,'0')
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
        f_name = "70273_"+d.year.to_s+d.month.to_s.rjust(2,'0')+d.day.to_s+seq
        z.put_next_entry("#{f_name}.blm")
        remote_data = render_to_string "download_blm5", :layout => false
        remote_data = remote_data.gsub("<pre>","")
        remote_data = remote_data.gsub("</pre>","")
        remote_data = remote_data.gsub("&lt;","<")
        remote_data = remote_data.gsub("&gt;",">")
        remote_data = remote_data.gsub("&quot;","'")
        z.print remote_data
      end
      require 'net/ftp'
      Net::FTP.open('ftp.zoopla.com', 'sealproperties_ne8', 'v5ZUFVQBjDKZ') do |ftp|
        ftp.passive = true
        # ftp.chdir("/live/upload")
        ftp.putbinaryfile(t.path,"70273.zip")
      end
      t.close
    end
    redirect_to root_url, notice: "Zoopla Uploading is start...."
  end

  def upload_pdf
    Thread.new do
    @property = Property.find(params[:id])
    sp = "sp"+@property.created_at.year.to_s.split(//).last(2).join()+@property.created_at.month.to_s.rjust(2,'0')+@property.id.to_s.rjust(4,'0')
    data = open("http://www.sealproperties.co.uk/brochure.pdf?id="+params[:id])
    puts data
    service = S3::Service.new(:access_key_id => ENV['AWS_ACCESS_KEY'],:secret_access_key => ENV['AWS_SECRET_KEY'])
    bucket = service.buckets.find("#{ENV['AWS_BUCKET']}")
    object = bucket.objects.build("brochure_"+sp+".pdf")
    puts object
    object.content = data
    object.save
    @property.brochure_link = "http://#{ENV['AWS_BUCKET']}.s3.amazonaws.com/brochure_"+sp+".pdf"
    @property.save
    end
    render :json => {:status => "ok"}
  end

  def delete_pdf
    @property = Property.find(params[:id])
    sp = "sp"+@property.created_at.year.to_s.split(//).last(2).join()+@property.created_at.month.to_s.rjust(2,'0')+@property.id.to_s.rjust(4,'0')
    service = S3::Service.new(:access_key_id => ENV['AWS_ACCESS_KEY'],:secret_access_key => ENV['AWS_SECRET_KEY'])
    bucket = service.buckets.find("#{ENV['AWS_BUCKET']}")
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

  def properties_available
    @properties = Property.where("approval_status = ? AND status = ?", "approved", "Available").includes(:user).includes(:agent)
  end

  def properties_let_agreed
    @properties = Property.where("approval_status = ? AND status = ? AND managed = ?", "approved", "Let Agreed", false).includes(:user).includes(:agent)
  end

  def properties_managed
    @properties = Property.where("approval_status = ? AND status = ? AND managed = ?", "approved", "Let Agreed", true).includes(:user).includes(:agent).includes(:tenants)
  end

  def properties_sale
    @properties = Property.where("category = ?", "Sale").where("stage = ? OR status = ?", "Available", "Available").includes(:user).includes(:agent)
  end

  def properties_sold
    @properties = Property.where("category = ?", "Sale").where("stage = ? OR status = ? OR status = ?", "SSTC", "SSTC", "SSTCM").includes(:user).includes(:agent).includes(:tenant)
  end

  def properties_seller
    @properties = Property.all.includes(:user)
  end

  def properties_buyer
    @properties = Property.all.includes(:user)
  end

  def upload_document(file, file_name, property, action)
    service = S3::Service.new(:access_key_id => ENV['AWS_ACCESS_KEY'],:secret_access_key => ENV['AWS_SECRET_KEY'])
    bucket = service.buckets.find("#{ENV['AWS_BUCKET']}")

    file.original_filename = "#{Time.now.to_i}/#{file.original_filename}"
    if action=="update" && file_name.include?("vetting_doc")
      property.property_documents.create(name: file_name, url: property.vetting.send(file_name) ) if !property.vetting.blank?
    elsif action=="update" && !property.send(file_name).blank?
      # a= property.send(file_name).split("https://#{ENV['AWS_BUCKET']}.s3.amazonaws.com/").last
      # object = bucket.objects.find(a)
      # object.destroy if object
      property.property_documents.create(name: file_name, url: property.send(file_name), date_completed: property.send("#{file_name}_date_complete"), due_date: property.send("#{file_name}_due_date") )
    end
    object = bucket.objects.build(file.original_filename)
    object.content = file.tempfile
    object.save
    return "https://#{ENV['AWS_BUCKET']}.s3.amazonaws.com/"+file.original_filename
  end

  def set_landlord_tenant(email, user, action)
    if email.blank?
      return (user=="landlord") ? current_user.id : nil
    elsif User.find_by_email(email).blank?
      params["property"]["user"].merge(status: "tenant", password: "12345678", password_confirmation: "12345678")
      u= User.new((user=="landlord") ? user_params : tenant_params)
      u.skip_confirmation!
      u.save
      return u.id
    else
      User.find_by_email(email).update_attributes((user=="landlord") ? user_params : tenant_params) if action=="update"
      return User.find_by_email(email).id
    end
  end

  def get_key
    @key = Key.where(key_status: "unassign").first
    render :json => {data: @key}.to_json 
  end

  def properties_prospective
    @properties = Property.where.not("approval_status = ?", "approved").includes(:user).includes(:agent)
  end

  def properties_reserved
    @properties = Property.where("approval_status = ? AND status = ?", "approved", "Reserved").includes(:user).includes(:agent)
  end

  def properties_seller_prospective
    @other_users = Appraisal.where(status: "Selling").all
  end

  def upload_property_doc(doc)
    unless doc[:property_doc].blank?
      service = S3::Service.new(:access_key_id => ENV['AWS_ACCESS_KEY'],:secret_access_key => ENV['AWS_SECRET_KEY'])
      bucket = service.buckets.find("#{ENV['AWS_BUCKET']}")

      doc[:property_doc].original_filename = "#{Time.now.to_i}/#{doc[:property_doc].original_filename}"      
      object = bucket.objects.build(doc[:property_doc].original_filename)
      object.content = doc[:property_doc].tempfile
      object.save
      return "https://#{ENV['AWS_BUCKET']}.s3.amazonaws.com/"+doc[:property_doc].original_filename
    end
  end

  private
    def set_property
      @property = Property.friendly.find(params[:id])
    end

    def property_params
      params.require(:property).permit(:name, :address1, :address2, :address3, :postcode, :bath, :beds, :parking, :category, :image1, :image2, :image3, :image4, :image5, :image6, :image7, :image8, :image9, :image10, :description, :date, :visibility, :price, :let, :sold, :featured, :approved, :payment, :user_id, :agent_id, :coordinates, :latitude, :longitude,:gas_ch,:glazing,:parking_status,:car,:short_description,:tag_line,:dg,:garden,:seal_approved,:property_type,:pets,:ensuite,:town,:status,:postcode1,:qualifier,:summary,:furnished,:feature1,:feature2,:epc,:brochure_link,:let_type_id,:let_furn_id,:let_date_available,:otm, :approval_status, :accredited, :licensed, :tenant_criteria, :cp12, :esc, :bond, :deal, :stage, :managed, :board, :tenant_id, :let_agreed_date, :sold_date, :marketing_notes, :epc_date_complete, :epc_due_date,:cp12_date_complete, :cp12_due_date,:esc_date_complete, :esc_due_date, :dss_move, :mouse_price,:home,:wonder_property, :key_assign_date, :key_unassign_date, :po, :zoopla, :nethouse, :portal_visibility, :let_rent_frequency, 
        vetting_attributes: [ :vetting_type, :submission_date, :outcome_date, :outcome, :vetting_doc, :guarantor ], 
        property_info_attributes: [:battery, :battery_operated, :mains, :mains_operated, :carbon, :carbon_monoxide, :elec_meter_loc, :elec_last_supplier, :gas_meter_loc, :gas_last_supplier, :gas_valve, :water_meter_loc, :water_stopcock_loc, :bin_coll_day, :alarm_loc, :alarm_code ,:property_id], 
        guarantor_attributes: [:firstname,:lastname,:previous_name,:dob,:address1,:address2,:address3,:postcode,:home_tel,:mobile_tel,:email,:emp_status,:emp_from,:job_title,:annual_inc,:ref_name,:ref_job,:ref_company,:ref_address,:ref_tel,:ref_email,:ref_rel,:outcome,:add_info,:property_id],
        right_to_rent_attributes: [:date_check,:expiry_doc,:doc_recheck,:recheck_due,:property_id ],
        tenancy_term_attributes: [ :start_date,:tenancy_length,:agreed_rent,:agreed_bond,:advanced_payment,:shared,:garden,:parking,:other,:water,:council_tax,:gas,:electricity,:tv_licence,:telephone,:broadband,:inventory,:guarantor_agreement,:epc,:rent_guide,:smoke_alarm,:pet,:property_id ],
        pet_detail_attributes: [ :pet_name,:pet_type,:pet_breed,:pet_age ,:property_id ]
      )
    end

    def property_changes_params
      params.require(:property).permit(:name, :address1, :address2, :address3, :postcode, :bath, :beds, :parking, :category, :image1, :image2, :image3, :image4, :image5, :image6, :image7, :image8, :image9, :image10, :description, :date, :visibility, :price, :let, :sold, :featured, :approved, :payment, :agent_id, :coordinates, :latitude, :longitude,:gas_ch,:glazing,:parking_status,:car,:short_description,:tag_line,:dg,:garden,:seal_approved,:property_type,:pets,:ensuite,:town,:status,:postcode1,:qualifier,:summary,:furnished,:feature1,:feature2,:epc,:brochure_link,:let_type_id,:let_furn_id,:let_date_available,:otm, :approval_status, :accredited, :licensed, :tenant_criteria, :cp12, :esc, :bond, :deal, :stage, :managed, :board)
    end

    def property_image_params
      params.require(:property).permit(:image1, :image2, :image3, :image4, :image5, :image6, :image7, :image8, :image9, :image10,:epc)
    end

    def user_params
      params.require(:property).require(:user).permit(:first_name,:last_name, :address1, :address2, :address3,:phone,:postcode,:mobile,:dob,:status,:password,:password_confirmation,:email, :avatar, :notes)
    end

    def tenant_params
      params.require(:property).require(:tenant).permit(:first_name,:last_name, :address1, :address2, :address3,:phone,:postcode,:mobile,:dob,:status,:password,:password_confirmation,:email, :tenant_status, :avatar)
    end
end