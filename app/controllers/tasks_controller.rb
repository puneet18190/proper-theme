class TasksController < ApplicationController
  layout proc { false if request.xhr? }	
  def index
    @search = Property.search(params[:q])
    @tasks = @search.result
  #  @tasks= Property.all
  end
  #
  # def upload_step2
  #   redirect_to upload_step3_path, :notice => "Payment details has been sent to your email"
  # end

  def properties_detail
    @data = Property.friendly.find(params[:id])
  end

  def upload_step1
    @property = Property.new
  end

end
