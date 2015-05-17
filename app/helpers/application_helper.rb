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
          image.url(:small)
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
end
