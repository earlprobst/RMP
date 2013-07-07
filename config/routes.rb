#-----------------------------------------------------------------------------
#
# Biocomfort Diagnostics GmbH & Co. KG
#            Copyright (c) 2008 - 2012. All Rights Reserved.
# Reproduction or modification is strictly prohibited without express
# written consent of Biocomfort Diagnostics GmbH & Co. KG.
#
#-----------------------------------------------------------------------------
#
# Contact: vollmer@biocomfort.de
#
#-----------------------------------------------------------------------------
#
# Filename: routes.rb
#
#-----------------------------------------------------------------------------

RemoteManagementPlatform::Application.routes.draw do

  get "activations/create"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  match 'logout' => 'user_sessions#destroy', :as => :logout
  match 'login' => 'user_sessions#new', :as => :login
  match 'activate/:activation_code' => 'activations#create', :as => :activate
  match 'account' => 'users#show'

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products
  resource :user_session
  resources :password_resets, :only => [ :new, :create, :edit, :update ]
  resources :users
  resources :projects
  resources :gateways do
    resources :medical_devices do
      resources :measurements
      match 'last_measurement' => 'measurements#show', :defaults => {:last => true}
      match 'current_state' => 'medical_device_states#show', :defaults => {:current => true}
    end
    resource :configuration, :only => [:show]
    resources :log_files, :only => [:destroy]
    resources :system_states, :only => [:index]
    match 'clear_log_files' => 'gateways#clear_log_files'
  end

  resources :measurements, :only => [:index]

  namespace :api do
    match 'configuration/state' => 'configuration_states#show'
    resource :configuration, :only => [:show]
    resources :measurements, :only => [:create, :show, :index]
    resources :tokens, :only => [:create]
    resources :log_files, :only => [:create]
    resource :time, :only => [:show]
    resources :system_states, :only => [:create, :show]
    resources :actions, :only => :index
  end

  namespace :query_api do
    resources :patients, :only => [:index]
    resources :measurements, :only => [:index]
  end

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"
  root :to => "gateways#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
