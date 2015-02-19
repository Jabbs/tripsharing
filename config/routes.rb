require 'sidekiq/web'
Rails.application.routes.draw do
  
  resources :surveys, only: [:create]
  resources :trips
  match 'lonelyplanet', to: 'trips#lonelyplanet', via: [:get]

  # facebook omniauth
  match 'auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  match 'auth/failure', to: redirect('/'), via: [:get, :post]
  match 'signout', to: 'sessions#destroy', as: 'signout', via: [:get, :post]
  
  # static pages
  # match '/about', to: 'static_pages#about', via: :get
  # match '/how_it_works', to: 'static_pages#how_it_works', via: :get
  # match '/privacy', to: 'static_pages#privacy', via: :get
  # match '/terms', to: 'static_pages#terms', via: :get
  # match '/press', to: 'static_pages#press', via: :get
  
  resources :users do
    resources :verifications, only: [:show]
    match '/resend_verification', to: "verifications#resend", via: :get
    resources :interests
    get 'profile'
    get 'join'
    # resources :trips
  end
  resources :password_resets, only: [:new, :create, :edit, :update]
  match '/unsubscribe', to: "verifications#unsubscribe", via: :get
  match '/unsubscribed', to: "static_pages#unsubscribed", via: :get
  match '/home', to: "static_pages#home", via: :get
  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end
  root :to => 'static_pages#home'
  mount Sidekiq::Web, at: '/sidekiq'
  
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
