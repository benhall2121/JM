Jm::Application.routes.draw do
  
  resources :abouts

  resources :site_guides

  resources :faqs

  resources :pages
  
  resources :histories

  root :to => "users#new"	
	
  resources :commentaries do
  	  get :shareable, :on => :collection
  end
  
  resources :boosts
	
  resources :users, :user_sessions
  match 'login' => 'user_sessions#new', :as => :login
  match 'logout' => 'user_sessions#destroy', :as => :logout
  
  match 'signin' => 'users#new', :as => :signin
  match 'create_boost/(:commentaries_id)' => 'boosts#create', :as => :create_boost
  match 'destroy_boost/(:commentaries_id)' => 'boosts#destroy', :as => :destroy_boost
  
  match '/(:permalink)' => 'pages#show', :permalink => 'about'
  
  match '/history/poll_taken' => 'users#poll_taken'
  match '/commentaries/share_commentary' => 'commentaries#share_commentary'
  match '/commentaries/get_link_info' => 'commentaries#get_link_info'
  match '/commentaries/create' => 'commentaries#create'
  
  match '/shared_commentary/:shared_user_username/:unique_id/:commentary_title' => 'commentaries#show'
  match '/shared_commentary/:shared_user_username/:unique_id' => 'commentaries#show'
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

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

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
