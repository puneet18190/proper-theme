class TasksController < ApplicationController
  layout proc { false if request.xhr? }	
  def index
    @properties = Property.where({payment: true, visibility: true})
    @search = @properties.search(params[:q])
    @tasks = @search.result
    @agents= Agent.all
    @news= News.all
  end

  def properties_detail
    begin
      @data = Property.friendly.find(params[:id])
      redirect_to root_url, alert: "No Property Found" unless @data.payment == true
    rescue Exception => e
      redirect_to root_url, alert: "No Property Found"
    end
  end

  def upload_step1
    @property = Property.new
  end

  def search_results
    @properties = Property.where({payment: true, visibility: true})
    @search = @properties.search(params[:q])
    @tasks = @search.result
  end

  def agents
    @agents= Agent.all
  end

end
