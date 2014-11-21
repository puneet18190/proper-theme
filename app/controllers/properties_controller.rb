class PropertiesController < ApplicationController
  before_action :set_property, only: [:show, :edit, :update, :destroy]
  respond_to :html, :xml, :json
  load_and_authorize_resource
  def index
    @properties = Property.all
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
    @property = Property.new(property_params)
    @property.save
    respond_with(@property)
    #redirect_to action: "index"
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

  private
    def set_property
      @property = Property.find(params[:id])
    end

    def property_params
      params.require(:property).permit(:name, :address1, :address2, :address3, :postcode, :bath, :beds, :parking, :category, :image1, :image2, :image3, :image4, :image5, :image6, :description, :date, :visibility, :price, :let, :sold, :featured )
    end
end
