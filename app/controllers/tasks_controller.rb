class TasksController < ApplicationController
  layout proc { false if request.xhr? }	
  def index
    @search = Property.search(params[:q])
    @tasks = @search.result
  #  @tasks= Property.all
  end

  def properties_detail
    @data = Property.find(params[:id])
  end

end
