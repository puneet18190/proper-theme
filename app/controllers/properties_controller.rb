class PropertiesController < ApplicationController
  # protect_from_forgery :except => "create"
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

  # def confirm_payment
  #
  # end

  # def payment_confirmation
  #   respond_to do |format|
  #     format.js
  #   end
  # end


  # def payment
  #     respond_to do |format|
  #       format.js
  #     end
  # end

  def search_property
    @search = Property.search(params[:q])
    @properties = @search.result
    
    if current_user.status == "tenant" && current_user.payment==false
      render :tenant_payment
    elsif current_user.status == "tenant" && current_user.payment==true
      render :tenant_search
    end


  end

  def approve
    @property = Property.find(params[:id])
    @status = params[:status]
    @property_id  = params[:id]
    if params[:status] == "Approve"
      @property.update_attributes(:approve=>true)
    else
      @property.update_attributes(:approve=>false)
    end  
    UserMailer.property_approval(@property,@status).deliver
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
    # redirect_to properties_landlord_payment_path
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
      @property.update_attributes(:payment=>true)
      UserMailer.deliver_payment_method(current_user)
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
    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to search_form_path
    end
  end   

  def tenant_search

  end

  private
    def set_property
      @property = Property.find(params[:id])
    end

    def property_params
      params.require(:property).permit(:name, :address1, :address2, :address3, :postcode, :bath, :beds, :parking, :category, :image1, :image2, :image3, :image4, :image5, :image6, :description, :date, :visibility, :price, :let, :sold, :featured, :approved, :payment, :user_id)
    end
end
