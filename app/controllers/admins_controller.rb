class AdminsController < ApplicationController
  before_action :set_admin, only: [:show, :edit, :update, :destroy]
  respond_to :html, :xml, :json
  def index
    @admins = Admin.all
    respond_with(@admins)
  end

  def show

  end

  def new
    @admin = Admin.new
    respond_with(@admin)
  end

  def edit
  end

  def create
    @admin = Admin.new(admin_params)
    @admin.save
    redirect_to action: "index"
  end

  def update
    @admin.update(admin_params)
    respond_with(@admin)
  end

  def destroy
    @admin.destroy
    respond_with(@admin)
  end

  private
    def set_admin
      @admin = Admin.find(params[:id])
    end

    def admin_params
      params.require(:admin).permit(:name, :price, :bath, :beds, :pools, :category, :image, :remote_image_url)
    end
end
