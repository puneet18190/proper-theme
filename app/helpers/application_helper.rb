module ApplicationHelper
  def notice
    flash[:notice]
  end

  def alert
    flash[:alert]
  end

  def gravatar_for(user, size = 30, title = user.name)
    image_tag gravatar_image_url(user.email, size: size), title: title, class: 'img-rounded'
  end

  def page_header(text)
    content_for(:page_header) { text.to_s }
  end

  def responsive_image(image)
    begin
      if request.ip == "82.68.0.86"
        image.url
      else
        if is_mobile_device?
          image.url(:medium)
        elsif ::MobileFu::Tablet.is_a_tablet_device? request.user_agent
          image.url(:medium)
        else
          image.url(:large)
        end      
      end
    rescue
      image.url
    end    
  end

  def property_status(category,status_id)
    if category == "Rent" && status_id == "Available"
      data = "To Let"
    elsif category == "Rent" && status_id == "Let Agreed"
      data = "Let Agreed"
    elsif category == "Sale" && status_id == "Available"
      data = "For Sale"
    elsif category == "Sale" && status_id == "SSTC"
      data = "Sold STC"
    elsif category == "Sale" && status_id == "SSTCM"
      data = "Sold STC"
    elsif category == "Sale" && status_id == "Reserved"
      data = "Reserved"
    elsif category == "Sale" && status_id == "Under Offer"
      data = "Under Offer"
    elsif category == "Rent" && status_id == "Reserved"
      data = "Reserved"  
    else
      data =""
    end
    return data
  end 

  def agent_name(property)
    property.agent.nil? ? property.user.first_name.capitalize : property.agent.name
  end

  def agent_phone(property)
    property.agent.nil? ? property.user.phone : property.agent.phone
  end

  def agent_email(property)
    property.agent.nil? ? "" : "#{property.agent.name.downcase}@sealproperties.co.uk"
  end

  def agent_image(property)
    property.agent.nil? ? "noimage.gif" : property.agent.image.url(:large).gsub("https","http")
  end

  def approve_btn(property)
    if property.approval_status == "approved"
      return "Approved"
    elsif property.approval_status == "waiting"
      return "Waiting for Approval"
    elsif property.approval_status == "submit"
      return "Waiting for Approval"
    elsif property.approval_status == "unapprove"
      return "Unapproved"
    elsif property.approval_status == "none"
      return "Submit for Approval"
    end
  end

  def approve_btn_class(property)
    if property.approval_status == "approved"
      return "btn btn-success approval-btn"
    elsif property.approval_status == "waiting"
      return "btn btn-danger"
    elsif property.approval_status == "submit"
      return "btn btn-primary approval-btn"
    elsif property.approval_status == "unapprove"
      return "btn btn-primary"
    elsif property.approval_status == "none"
      return "btn btn-primary approval-btn"
    end
  end

  def approve_status(property)
    if property.approval_status == "approved"
      return "approved"
    elsif property.approval_status == "waiting"
      return ""
    elsif property.approval_status == "submit"
      return ""
    elsif property.approval_status == "unapprove"
      return "submit"
    elsif property.approval_status == "none"
      return "waiting"
    end
  end 
end

def property_user(property)
  property.property_create_user=="admin" ? "shaded-purple" : "shaded-blue"
end

def get_extension(mac)
  if mac == "0015653b4906"
    return "Emma Bovingdon (2018701)"
  elsif mac == "0015654c6db2"
    return "Stephen Bovingdon (2018481)"
  elsif mac == "0015654c66c2"
    return "Emma Bovingdon (2018480)"
  else
    return "Stephen Bovingdon (2018700)"
  end

  def mobile_device?
    user_agent = request.headers["HTTP_USER_AGENT"]
    user_agent.present? && user_agent =~ /\b(Android|iPhone|iPad|Windows Phone|Opera Mobi|Kindle|BackBerry|PlayBook)\b/i
  end
end