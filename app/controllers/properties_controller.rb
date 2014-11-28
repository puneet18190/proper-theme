class PropertiesController < ApplicationController
  layout proc { false if request.xhr? }
  before_action :set_property, only: [:show, :edit, :update, :destroy]
  respond_to :html, :xml, :json
  load_and_authorize_resource
  def index
    if current_user.email == "admin@gmail.com"
      @properties = Property.all
    else
      @properties = Property.where(:user_id => current_user.id)
    end
    respond_with(@properties)
  end

  def show
    respond_with(@property)
  end


  def new
    if current_user.status == "landlord"
      @property = current_user.properties.new
    else
      @property = Property.new
    end  
    respond_with(@property)
  end

  def edit

  end

  def create
    if current_user.status == "landlord"
      @user = current_user
      @property = @user.properties.new(property_params)
      @property.save
      respond_to do |format|
        format.js
      end
    else
      @property = Property.new(property_params)
      respond_with(@property)
    end 
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

  def confirm_payment
    # binding.pry
    UserMailer.deliver_payment_method(current_user)
    respond_to do |format|
      format.js
    end
    #redirect_to upload_step3_path, :notice => "Payment details has been sent to your email"
  end

  def payment_confirmation
    respond_to do |format|
      format.js
    end
  end


  def payment
      respond_to do |format|
        format.js
      end
  end

  def search_property
    if current_user.status == "tenant" && current_user.payment==false
      render :payment
    elsif current_user.status == "tenant" && current_user.payment==true
      render :search_form
    end
  end

  private
    def set_property
      @property = Property.find(params[:id])
    end

    def property_params
      params.require(:property).permit(:name, :address1, :address2, :address3, :postcode, :bath, :beds, :parking, :category, :image1, :image2, :image3, :image4, :image5, :image6, :description, :date, :visibility, :price, :let, :sold, :featured, :approved, :payment, :user_id)
    end
end
