class TasksController < ApplicationController
  layout proc { false if request.xhr? }	
  respond_to :html, :xml, :json,:mobile, :tablet
  def index
    if  request.format.symbol == :mobile
      render :nothing => true
    else
      if !current_user.nil? && current_user.sign_in_count == 1
        redirect_to "/users/profile"
      else
      # if is_mobile_device? == false
        @properties = Property.where({visibility: true, approval_status: "approved"}).order("status ASC,created_at DESC")

        if !params[:q].nil? && params[:q][:radius]!="Select"
          @properties = @properties.near(params[:q][:postcode_eq],params[:q][:radius].to_f)
        end

        params[:q].delete("postcode_eq") if params[:q] && params[:q][:postcode_eq]
        params[:q].delete("radius") if params[:q] && params[:q][:radius]

        @search = @properties.search(params[:q])
        #@locations = Property.near(params[:q][:address1],params[:q][:radius].to_f) unless params[:q].nil?
        # unless params[:q].nil?
        #   @result = []
        #   @result.push(@search.result)
        #   @result.push(@locations) unless @locations.nil?
        #   @tasks = @result.flatten
        # else
        @tasks = @search.result

        # end
        @agents= Agent.all.first 2
        @news= News.all
        @settings = Setting.all.first
        respond_with(@properties,@search,@tasks,@agents,@news,@settings)
      # else
      #   @properties = Property.where({payment: true, visibility: true, approve: true}).take(3)
      #   @agents= Agent.all
      #   render "mobile/index.html.erb"#,:layout => "mobile"
      # end
      end  
    end
  end

  def home_simple
    if  request.format.symbol == :mobile
      redirect_to "/"
    else
      @properties = Property.where({visibility: true, approval_status: "approved"}).order("status ASC,created_at DESC")
      @search = @properties.search(params[:q])
      @tasks = @search.result
      @agents= Agent.all.first 2
      @news= News.all
      respond_with(@properties,@search,@tasks,@agents,@news)
    end
  end

  def properties_detail
      begin
        @data = Property.friendly.find(params[:id])
        @agents = @data.agent
        @contact_agent = ContactAgent.new
      rescue Exception => e
        redirect_to root_url, alert: "No Property Found. "
      end
      respond_with(@data,@agents,@contact_agent)
  end

  def properties_filter
    condition = params[:condition].blank? ? "price" : params[:condition]
    sort = params[:sort].blank? ? "asc" : params[:sort]
    type = params[:type].blank? ? "all" : params[:type]
      
    if type=="all"
      @data = Property.where({visibility: true, approval_status: "approved"}).page(params[:page].blank? ? 1 : params[:page]).per(5).order("#{condition} #{sort}").includes(:agent).includes(:user).order("status ASC,created_at DESC")
    elsif type=="to_let"
      @data = Property.where({visibility: true, approval_status: "approved", status: "Available", category: "Rent"}).page(params[:page].blank? ? 1 : params[:page]).per(5).order("#{condition} #{sort}").includes(:agent).includes(:user).order("status ASC,created_at DESC")
    else
      @data = Property.where({visibility: true, approval_status: "approved", status: "Available", category: "Sale"}).page(params[:page].blank? ? 1 : params[:page]).per(5).order("#{condition} #{sort}").includes(:agent).includes(:user).order("status ASC,created_at DESC")
    end      
    @agents = Agent.all.first 2
    respond_with(@data,@agents)
  end

  def properties_map
    @prop = Property.all.order("created_at DESC")
    @agents = Agent.all.first 2
    respond_with(@prop,@agents)
  end

  def upload_step1
    @property = Property.new
  end

  def search_results
    @properties = Property.where({visibility: true, approval_status: "approved"}).order("created_at DESC")
    @tasks = []
    if !params[:q][:name_cont].nil?
      z=params[:q][:name_cont]
      @tasks << @properties.where("address1  ILIKE ? OR address2 ILIKE ? OR address3 ILIKE ? OR description ILIKE ? OR category ILIKE ? OR name ILIKE ? OR short_description ILIKE ? OR tag_line ILIKE ? OR town ILIKE ? OR price = ? OR postcode = ? OR postcode1 = ?", "%#{z}%","%#{z}%","%#{z}%","%#{z}%","%#{z}%","%#{z}%","%#{z}%","%#{z}%","%#{z}%","#{z.to_i}","#{z.to_i}","#{z.to_i}" ) if (z.to_i == 0 && !z.include?('bed') && !z.include?('bath') )
      # c=['address1', 'address2', 'address3','amount', 'amount','bath','beds','parking','description','category','price','name','postcode','short_description','tag_line','town','postcode1','summary']
      if @tasks.empty?
        params[:q][:name_cont].split.each do |z|
          # @tasks << Property.where("address1  ILIKE ? OR address2 ILIKE ? OR address3 ILIKE ? OR description ILIKE ? OR category ILIKE ? OR name ILIKE ? OR short_description ILIKE ? OR tag_line ILIKE ? OR town ILIKE ? OR price = ? OR postcode = ? OR postcode1 = ? OR bath = ? OR beds = ?", "%#{z}%","%#{z}%","%#{z}%","%#{z}%","%#{z}%","%#{z}%","%#{z}%","%#{z}%","%#{z}%","#{z.to_i}","#{z.to_i}","#{z.to_i}","#{z.to_i}","#{z.to_i}" )
          @tasks << @properties.where("address1  ILIKE ? OR address2 ILIKE ? OR address3 ILIKE ? OR description ILIKE ? OR category ILIKE ? OR name ILIKE ? OR short_description ILIKE ? OR tag_line ILIKE ? OR town ILIKE ? OR price = ? OR postcode = ? OR postcode1 = ?", "%#{z}%","%#{z}%","%#{z}%","%#{z}%","%#{z}%","%#{z}%","%#{z}%","%#{z}%","%#{z}%","#{z.to_i}","#{z.to_i}","#{z.to_i}" ) if (z.to_i == 0 && !z.include?('bed') && !z.include?('bath') )
        end
        s= params[:q][:name_cont]
        @tasks << @properties.where("beds = ?" ,"#{s.split(' bed')[0].last.to_i}" ) if s.split(' bed')[0].last.to_i != 0
        @tasks << @properties.where("bath = ?" ,"#{s.split(' bath')[0].last.to_i}" ) if s.split(' bath')[0].last.to_i != 0
      end

      @tasks = @tasks.flatten.uniq
      @status = false
    else
      if params[:q][:postcode_cont] != ""
        address2 = @properties.search(:address2_cont => params[:q][:postcode_cont])
        unless address2.result.empty?
          params[:q][:address2_cont] = params[:q][:postcode_cont]
        end

        address3 = @properties.search(:address3_cont => params[:q][:postcode_cont])
        unless address3.result.empty?
          params[:q][:address3_cont] = params[:q][:postcode_cont]
        end

        postcode = @properties.search(:postcode_cont => params[:q][:postcode_cont])
        if postcode.result.empty?
          params[:q].delete("postcode_cont")
        end
      end
      @search = @properties.search(params[:q])
      @tasks = @search.result
      @status = true
    end
  end

  def agents
    @agents=  Agent.all.includes(:properties).first(2)
    respond_with(@agents)
  end

  def contact
    @contact = Contact.new
    respond_with(@contact)
  end

  def con
    @contact = Contact.new(con_params)
    if verify_recaptcha
      @contact.save!
      redirect_to "/contact", notice: "Thank you for your enquiry. We will be in touch shortly."
    else
      redirect_to "/contact", alert: "Please re-enter captcha......"
    end
  end

  def contact_agent
    @contact_agent = ContactAgent.new(contact_agent_params)
    @contact_agent.save
    UserMailer.query_message(@contact_agent).deliver
    @setting = Setting.all[0]
    if !@setting.sms_destination_no.blank? && @setting.send_sms_on_msg
      HTTParty.post("https://call-api.gradwell.com/0.9.3/sms",:body=>{ 
        :auth=>'4KPDJWZRFOXXS50KXPOA4VTM4S', 
        :originator=>441915805900, 
        :destination=>@setting.sms_destination_no, 
        :message=>"Name: #{params[:contact_agent][:name]},  Property: #{params[:contact_agent][:page_link].split("/").last}, message: #{params[:contact_agent][:message]}"})
    end
    redirect_to :back, notice: "We will be in touch shortly. "
  end

  def sitemap
    @static_pages = [root_url, contact_url]
    @property = Property.all
  end  

  def news
    @news = News.all

    @p_title = []
    @p_description = []
    @p_image = []
    agent = Mechanize.new
    page = agent.get('http://www.propertyreporter.co.uk/rss.asp')
    response = Nokogiri::XML::Document.parse(page.body, nil, "UTF-8")
    response.css('title').each do |t|
      @p_title.push(t.text)
    end  
    response.css('description').each do |t|
      @p_image.push(t.text.split("<br />")[0])
      @p_description.push(t.text.split("<br />")[1])
    end
    respond_with(@p_title,@p_image,@p_description )
  end  

  def testimonials
    @testimonials = Testimonial.all
    respond_with(@testimonials)
  end

  def seal_approved

  end

  private
  def con_params
    params.require(:contact).permit(:first_name, :last_name, :email_id, :contact_number, :comments)
  end

  def contact_agent_params
    params.require(:contact_agent).permit(:name, :email, :message, :agent_id, :page_link)
  end
end
