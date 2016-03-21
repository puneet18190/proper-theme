Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  resources :properties do
    member do 
      get 'change'
    end
  end
  mount Browserlog::Engine => '/logs'
  resources :property_changes
  resources :mails
  # resources :advertisements
  devise_for :users, controllers: { confirmations: "confirmations", sessions: "sessions" }

  root 'tasks#index'
  post 'properties/approve'
  # post 'properties/confirm_payment'
  # post 'properties/payment_confirmation'
  get "/404" => "errors#not_found"
  get "/500" => "errors#internal_server_error"
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
  match '/testimonials',   to: 'tasks#testimonials',   via: 'get'
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

  resources :messages, only: [:new, :create] do
    collection do
      post :contact_landlord
      get :contact_agent
    end
  end

  match 'search_results', to: 'tasks#search_results', via: [:get, :post]
  match 'pdf_handle', to: 'properties#pdf_handle', via: 'get'
  match 'brochure', to: 'properties#brochure', via: 'get'
  match 'brochure1', to: 'properties#brochure1', via: 'get'
  match 'brochure2', to: 'properties#brochure2', via: 'get'
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
  # match '/landlords',   to: 'screens#landlords', via: 'get'
  # match '/tenants',   to: 'screens#tenants', via: 'get'
  match '/mobiles',   to: 'screens#mobiles', via: 'get'
  match '/services',   to: 'screens#services', via: 'get'
  match '/uploadfile',   to: 'screens#uploadfile', via: 'post'
  match '/delete_file',   to: 'screens#delete_file_from_s3', via: 'get'
  match '/provisioning/:id',   to: 'screens#provisioning_files', via: 'get'
  match '/mail_merge',   to: 'screens#mail_merge', via: 'get'
  match '/mail_merge_uploadfile',   to: 'screens#mail_merge_uploadfile', via: 'post'
  get "sitemap.xml" => "tasks#sitemap", as: "sitemap", defaults: { format: "xml" }
  match '/api_for_dashing',   to: 'screens#api_for_dashing', via: 'get'
  match '/blm',   to: 'properties#blm', via: 'get'
  match '/blm1',   to: 'properties#blm1', via: 'get'
  match '/blm2',   to: 'properties#blm2', via: 'get'
  match '/blm3',   to: 'properties#blm3', via: 'get'
  match '/blm4',   to: 'properties#blm4', via: 'get'
  match '/download_blm',   to: 'properties#download_blm', via: 'get'
  match '/zip_blm',   to: 'properties#zip_blm', via: 'get'
  match '/upload_blm',   to: 'properties#upload_blm', via: 'get'
  match '/upload_blm_mouseprice',   to: 'properties#upload_blm_mouseprice', via: 'get'
  match '/upload_blm_dssmove',   to: 'properties#upload_blm_dssmove', via: 'get'
  match '/upload_pdf',   to: 'properties#upload_pdf', via: 'get'
  match '/delete_pdf',   to: 'properties#delete_pdf', via: 'get'
  match '/test_blm',   to: 'properties#test_blm', via: 'get'
  match '/search_criteria',   to: 'properties#search_criteria', via: 'get'
  match '/help',   to: 'phones#help',   via: 'get'
  
  resources :users do
    collection do 
      get 'profile'
    end

    member do
      post 'contact_notes'
    end
  end

  resources :landlords
  resources :tenants  
  match '/seal_approved',   to: 'tasks#seal_approved',   via: 'get'
  match '/matches',   to: 'users#matches',   via: 'get'
  match 'featured_inside', to: 'screens#featured_inside', via: 'get'
  match 'random_inside', to: 'screens#random_inside', via: 'get'
  match 'cycle_inside', to: 'screens#cycle_inside', via: 'get'
  match 'oldest_inside', to: 'screens#oldest_inside', via: 'get'
  match 'newest_inside', to: 'screens#newest_inside', via: 'get'
  match 'screens/inside_properties_detail/:property_id',   to: 'screens#inside_properties_detail',   via: 'get'

  match '/available',   to: 'properties#properties_available',   via: 'get'
  match '/let_agreed',   to: 'properties#properties_let_agreed',   via: 'get'
  match '/managed',   to: 'properties#properties_managed',   via: 'get'
  match '/sale',   to: 'properties#properties_sale',   via: 'get'
  match '/sold',   to: 'properties#properties_sold',   via: 'get'
  match '/seller',   to: 'properties#properties_seller',   via: 'get'
  match '/buyer',   to: 'properties#properties_buyer',   via: 'get'
  get 'users/autocomplete_user_email'
  get 'users/autocomplete_user_tenant'
  get 'users/autocomplete_user'
  match '/get_user_data',   to: 'users#get_user_data',   via: 'get'
  match 'get_phone_data', to: 'phones#get_phone_data', via: 'get'
  match 'get_call_handler', to: 'phones#get_call_handler', via: 'get'
  match 'send_sms_to_user', to: 'phones#send_sms_to_user', via: 'get'
  match 'record_search', to: 'phones#record_search', via: 'get'
  match 'send_sms', to: 'sms#send_sms', via: 'post'
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
  match '/make_call',   to: 'phones#make_call',   via: 'get'
  match '/get_call_handler',   to: 'phones#get_call_handler',   via: 'get'
end
