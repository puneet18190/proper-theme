module MessagesHelper
  def recipients_options(user)
    s = ''
    @user = user.blank? ? User.all : User.where(email: user)
    @user.all.each do |user|
      s << "<option value='#{user.id}'>#{user.first_name} #{user.last_name unless user.last_name.blank?}</option>"
    end
    s.html_safe
  end
end