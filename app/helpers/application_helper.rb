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
end
