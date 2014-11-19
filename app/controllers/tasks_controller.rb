class TasksController < ApplicationController
  def index
    @search = Property.search(params[:q])
    @tasks = @search.result
  end
end
