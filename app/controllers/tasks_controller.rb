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

  def contact
    @contact = Contact.new
  end

  def con
    @contact = Contact.new(con_params)
    if verify_recaptcha
      @contact.save!
      redirect_to "/contacts", notice: "Thank You for posting your query, we will come back to you soon......"
    else
      redirect_to "/contacts", alert: "Please re-enter captcha......"
    end
  end

  private
  def con_params
    params.require(:contact).permit(:first_name, :last_name, :email_id, :contact_number, :comments)
  end

end
