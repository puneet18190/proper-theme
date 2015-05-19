class PropertiesController < ApplicationController
  layout proc { false if request.xhr? }
  before_action :set_property, only: [:show, :edit, :update, :destroy]
  respond_to :html, :xml, :json
  load_and_authorize_resource
  #protect_from_forgery except: [:disconnect_fb] 
  def index
    if current_user.status == "admin"
      @properties = Property.order("created_at DESC")
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
    if current_user.status == "tenant" && current_user.payment==false
      render :tenant_payment
    elsif current_user.status == "tenant" && current_user.payment==true
      render :tenant_search
    end
  end

  def tenant_search_result
    @user = current_user
    @search = Property.search(params[:q])
    @properties = @search.result
    @request = request.host_with_port
    @abc = params[:q]
    name = @abc[:name_cont]
    category = @abc[:category_cont]
    price_less_than = @abc[:price_lteq]
    price_greater_than = @abc[:price_gteq]
    beds = @abc[:beds_eq]
    bath = @abc[:bath_eq]
    @user.search = "#{name},#{category},#{price_less_than},#{price_greater_than},#{beds},#{bath}"
    @user.search.downcase
    @user.save
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
    caption =     "#{@property.description} | #{@property.address3}"
    description =  @property.description || "N.A."
    picture_url =  "http://"+request.host_with_port+"/assets/R03R.png"

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

  private
    def set_property
      @property = Property.friendly.find(params[:id])
    end

    def property_params
      params.require(:property).permit(:name, :address1, :address2, :address3, :postcode, :bath, :beds, :parking, :category, :image1, :image2, :image3, :image4, :image5, :image6, :image7, :image8, :image9, :image10, :description, :date, :visibility, :price, :let, :sold, :featured, :approved, :payment, :user_id, :agent_id, :coordinates, :latitude, :longitude)
    end

end