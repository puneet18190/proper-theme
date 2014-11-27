class PropertiesController < ApplicationController
  layout proc { false if request.xhr? } 
  before_action :set_property, only: [:show, :edit, :update, :destroy]
  respond_to :html, :xml, :json
  load_and_authorize_resource
  def index
    @properties = Property.where(:user_id => current_user.id)
    respond_with(@properties)
  end

  def show
    respond_with(@property)
  end


  def new
    @property = Property.new
    respond_with(@property)
  end

  def edit

  end

  def create
    @user = current_user
    @property = @user.properties.new(property_params)
    #@property = Property.new(property_params)
    @property.save
    #respond_with(@property)
   redirect_to upload_step2_path
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

  def payment
    # binding.pry

    UserMailer.deliver_payment_method(current_user)
    redirect_to upload_step3_path, :notice => "Payment details has been sent to your email"
  end


  private
    def set_property
      @property = Property.find(params[:id])
    end

    def property_params
      params.require(:property).permit(:name, :address1, :address2, :address3, :postcode, :bath, :beds, :parking, :category, :image1, :image2, :image3, :image4, :image5, :image6, :description, :date, :visibility, :price, :let, :sold, :featured, :approved, :payment, :user_id)
    end
end
