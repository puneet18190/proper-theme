Rails.application.routes.draw do
  resources :properties
  devise_for :users, controllers: { confirmations: "confirmations" }

  root 'tasks#index'
  post 'properties/approve'
  post 'properties/confirm_payment'
  post 'properties/payment_confirmation'
  post 'properties/payment'
  match '/add',   to: 'tasks#add',   via: 'get'
  match '/index',   to: 'tasks#index',   via: 'get'
  match '/about_us',   to: 'tasks#about_us',   via: 'get'
  match '/login',   to: 'tasks#login',   via: 'get'
  match '/agents',   to: 'tasks#agents',   via: 'get'
  match '/career',   to: 'tasks#career',   via: 'get'
  match '/contact',   to: 'tasks#contact',   via: 'get'
  match '/custum-bg',   to: 'tasks#custum-bg',   via: 'get'
  match '/error_page',   to: 'tasks#error_page',   via: 'get'
  match '/faq',   to: 'tasks#faq',   via: 'get'
  match '/galeries',   to: 'tasks#galeries',   via: 'get'
  match '/grid_stystem',   to: 'tasks#grid_stystem',   via: 'get'
  match '/home_carousel',   to: 'tasks#home_carousel', via: 'get'
  match '/home_full_slider',   to: 'tasks#home_full_slider', via: 'get'
  match '/home_simple',   to: 'tasks#home_simple', via: 'get'
  match '/news',   to: 'tasks#news',   via: 'get'
  match '/news_detail',   to: 'tasks#news_detail',   via: 'get'
  match '/pricing',   to: 'tasks#pricing',   via: 'get'
  match '/properties_detail/:id',   to: 'tasks#properties_detail',   via: 'get'
  match '/properties_filter',   to: 'tasks#properties_filter',   via: 'get'
  match '/properties_map',   to: 'tasks#properties_map',   via: 'get'
  match '/shortcode',   to: 'tasks#shortcode',   via: 'get'
  match '/sing_up',   to: 'tasks#sing_up',   via: 'get'
  match '/typograpy',   to: 'tasks#typograpy',   via: 'get'
  match '/upload_step1',   to: 'tasks#upload_step1',   via: 'get'
  match '/upload_step2',   to: 'tasks#upload_step2',   via: 'get'
  match '/upload_step3',   to: 'tasks#upload_step3',   via: 'get'
  match '/upload_step4',   to: 'tasks#upload_step4',   via: 'get'
  match '/upload_step5',   to: 'tasks#upload_step5',   via: 'get'
  match '/upload_step6',   to: 'tasks#upload_step6',   via: 'get'


  match '/screen2/page1', to: 'screens#page1', via: 'get'
  match '/screen2/page2', to: 'screens#page2', via: 'get'


  match '/auto', to: 'screens#auto', via: 'get'

  match 'screen1', to: 'screens#screen1', via: 'get'
  match 'screen2', to: 'screens#screen2', via: 'get'
  match 'screen3', to: 'screens#screen3', via: 'get'
  match 'screens/screen_properties_detail/:property_id',   to: 'screens#screen_properties_detail',   via: 'get'

  match 'payment', to: 'properties#payment', via: 'get', format: 'js'

  match 'search_property', to: 'properties#search_property', via: 'get'
  match '/property/:id/landlord_payment', to: 'properties#landlord_payment', via: 'get'
  match '/property/:id/confirm_landlord_payment', to: 'properties#confirm_landlord_payment', via: 'post'
  match 'confirm_tenant_payment', to: 'properties#confirm_tenant_payment', via: 'post'
  match 'tenant_search', to: 'properties#tenant_search', via: 'post'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
