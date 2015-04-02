Rails.application.routes.draw do
  mount Dashing::Engine, at: Dashing.config.engine_path
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  resources :properties
  # resources :advertisements
  devise_for :users, controllers: { confirmations: "confirmations" }

  root 'tasks#index'
  post 'properties/approve'
  # post 'properties/confirm_payment'
  # post 'properties/payment_confirmation'
  post 'properties/payment'
  match '/add',   to: 'tasks#add',   via: 'get'
  match '/index',   to: 'tasks#index',   via: 'get'
  match '/about_us',   to: 'tasks#about_us',   via: 'get'
  match '/login',   to: 'tasks#login',   via: 'get'
  match '/agents',   to: 'tasks#agents',   via: 'get'
  match '/career',   to: 'tasks#career',   via: 'get'
  match '/contact',   to: 'tasks#contact',   via: [:get, :post]
  match '/custum-bg',   to: 'tasks#custum-bg',   via: 'get'
  match '/error_page',   to: 'tasks#error_page',   via: 'get'
  match '/faq',   to: 'tasks#faq',   via: 'get'
  match '/testimonials',   to: 'tasks#galeries',   via: 'get'
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

  match 'newest', to: 'screens#newest', via: 'get'
  match 'screens/newest_properties_detail/:property_id',   to: 'screens#newest_properties_detail',   via: 'get'


  match 'payment', to: 'properties#payment', via: 'get'

  match 'search_property', to: 'properties#search_property', via: 'get'
  match '/property/:id/landlord_payment', to: 'properties#landlord_payment', via: 'get'
  match '/property/:id/confirm_landlord_payment', to: 'properties#confirm_landlord_payment', via: 'post'
  match 'confirm_tenant_payment', to: 'properties#confirm_tenant_payment', via: 'post'
  match 'tenant_search', to: 'properties#tenant_search', via: 'get'
  match 'search_property', to: 'properties#search_property', via: 'get'
  match 'tenant_search_result', to: 'properties#tenant_search_result', via: 'get'
  match '/facebook_share/:property_id', to: 'properties#facebook_share', via: 'get'
  match 'payment_property', to: 'properties#payment_property', via: 'get'
  match 'tenant_payment', to: 'properties#tenant_payment', via: 'get'
  match '/impress', to: "screens#impress", via: 'get'

  get "/get_fb_token" => "properties#get_fb_token"
  post "/connect_facebook" => "properties#connect_facebook"
  get "/disconnect_fb" => "properties#disconnect_fb"
  match '/update_screen_status',   to: 'screens#update_screen_status',   via: 'post'
  match 'community', to: 'screens#community', via: 'get'
  match 'advertisements', to: 'properties#advertisements', via: 'get'

  match 'ad', to: 'properties#ad', via: 'get'

  resources :conversations, only: [:index, :show, :destroy] do
    member do
      post :reply
      post :restore
      delete :empty_trash
      post :mark_as_read
    end
  end

  resources :messages, only: [:new, :create]

  match 'search_results', to: 'tasks#search_results', via: [:get, :post]
  match 'pdf_handle', to: 'properties#pdf_handle', via: 'get'
  match 'con', to: 'tasks#con', via: [:get, :post]
  match 'contact_agent', to: 'tasks#contact_agent', via: 'post'
  match '/pricing_tenant',   to: 'tasks#pricing_tenant',   via: 'get'
  match 'featured', to: 'screens#featured_properties', via: 'get'
  match 'random', to: 'screens#random_properties', via: 'get'
  match 'cycle', to: 'screens#cycle', via: 'get'
  match 'oldest', to: 'screens#oldest', via: 'get'
  match 'screens/oldest_properties_detail/:property_id',   to: 'screens#oldest_properties_detail',   via: 'get'

  match '/crm', to: "rubyzohos#index", via: 'get'
  match 'crm_contact', to: 'rubyzohos#contact', via: [:get, :post]
  post 'rubyzohos/create_contact'
  match 'leads', to: 'rubyzohos#leads', via: [:get, :post]
  post 'rubyzohos/create_lead'
  match 'accounts', to: 'rubyzohos#accounts', via: [:get, :post]
  post 'rubyzohos/create_account'
  match 'tasks', to: 'rubyzohos#tasks', via: [:get, :post]
  post 'rubyzohos/create_task'
  match 'potential', to: 'rubyzohos#potential', via: [:get, :post]
  post 'rubyzohos/create_potential'
  
  match 'get_accounts', to: 'rubyzohos#get_accounts', via: [:get]
  match 'get_contacts', to: 'rubyzohos#get_contacts', via: [:get]
  match 'get_leads', to: 'rubyzohos#get_leads', via: [:get]
  match 'get_tasks', to: 'rubyzohos#get_tasks', via: [:get]
  match 'get_potentials', to: 'rubyzohos#get_potentials', via: [:get]
  post 'properties/approve_property'
  match '/pay_plans', to: "properties#pay_plans", via: 'get'
  match '/pay', to: "properties#pay", via: 'get'
  match '/my_plan', to: "properties#my_plan", via: 'get'
  match '/tenant_searching', to: "properties#tenant_searching", via: 'get'
  match '/landlord_free_plan',   to: 'properties#landlord_free_plan', via: 'get'
  match '/landlord_basic_plus_plan',   to: 'properties#landlord_basic_plus_plan', via: 'get'
  match '/landlord_pro_plan',   to: 'properties#landlord_pro_plan', via: 'get'
  match '/landlord_pro_plus_plan',   to: 'properties#landlord_pro_plus_plan', via: 'get'
  match '/tenant_free_plan',   to: 'properties#tenant_free_plan', via: 'get'
  match '/tenant_basic_plus_plan',   to: 'properties#tenant_basic_plus_plan', via: 'get'
  match '/tenant_pro_plan',   to: 'properties#tenant_pro_plan', via: 'get'

  match '/bigscreen',   to: 'screens#bigscreen', via: 'get'  # The priority is based upon order of creation: first created -> highest priority.
  match '/provisioning',   to: 'screens#provisioning', via: 'get'
  match '/PROVISIONING',   to: 'screens#provisioning', via: 'get'
  match '/phones',   to: 'screens#phones', via: 'get'
  match '/landlords',   to: 'screens#landlords', via: 'get'
  match '/tenants',   to: 'screens#tenants', via: 'get'
  match '/mobiles',   to: 'screens#mobiles', via: 'get'
  match '/services',   to: 'screens#services', via: 'get'
  match '/uploadfile',   to: 'screens#uploadfile', via: 'post'
  #match '/uploadfile',   to: 'screens#uploadfile', via: 'post'
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
