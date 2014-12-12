class PropertiesController < ApplicationController
  layout proc { false if request.xhr? }
  before_action :set_property, only: [:show, :edit, :update, :destroy]
  respond_to :html, :xml, :json
  load_and_authorize_resource
  def index
    if current_user.status == "admin"
      @properties = Property.all
    elsif current_user.status == "landlord"
      @properties = Property.where(:user_id => current_user.id)
    else
      @properties = Property.all
    end

    if current_user.status == "landlord"
      @properties.each do |obj|
        if (obj.payment == true && (obj.validity - DateTime.now.in_time_zone("UTC")) < 0)
            obj.update_attributes(:payment => false,:visibility=>false,:validity=>nil)
        end  
      end  
    end
    respond_with(@properties)
  end

  def show
    respond_with(@property)
  end


  def new
    unless current_user.status == "tenant"
      @property = current_user.properties.new  
      respond_with(@property)
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

      Stripe.api_key = "sk_test_UZ0dgBsgRJqY95p0wCPALgv8"
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
      Stripe.api_key = "sk_test_UZ0dgBsgRJqY95p0wCPALgv8"
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

  private
    def set_property
      @property = Property.friendly.find(params[:id])
    end

    def property_params
      params.require(:property).permit(:name, :address1, :address2, :address3, :postcode, :bath, :beds, :parking, :category, :image1, :image2, :image3, :image4, :image5, :image6, :description, :date, :visibility, :price, :let, :sold, :featured, :approved, :payment, :user_id)
    end
end
