ActiveAdmin.register Setting do
  permit_params :admin_image, :admin_text, :property_description, :newest_screen_text, :newest_screen, :oldest_screen_text, :oldest_screen, :featured_screen_text,:featured_screen, :random_screen_text,:random_screen,:cycle_screen_text,:cycle_screen
  form(:html => { :multipart => true }) do |f|
    f.inputs "Create Setting..." do
      f.input :admin_image, :as => :file
      f.input :admin_text
      f.input :property_description, as: :html_editor
      f.input :newest_screen_text
      f.input :newest_screen
      f.input :oldest_screen_text
      f.input :oldest_screen
      f.input :featured_screen_text
      f.input :featured_screen
      f.input :random_screen_text
      f.input :random_screen
      f.input :cycle_screen_text
      f.input :cycle_screen
    end
    f.actions
  end
end
