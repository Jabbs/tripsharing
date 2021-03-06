require 'sidekiq/web'
Rails.application.routes.draw do

  match 'viewed_message_badges', to: 'view_badges#viewed_message_badges', via: [:put]
  match 'viewed_notification_badges', to: 'view_badges#viewed_notification_badges', via: [:put]
  resources :surveys, only: [:create]
  resources :trips do
    get 'user_signup'
    get 'details'
    resources :invitations
    resources :followings, only: [:create, :destroy]
    resources :stops
    resources :join_requests, only: [:create] do
      match 'accept', to: 'join_requests#accept', via: [:put]
      match 'decline', to: 'join_requests#decline', via: [:put]
    end
    match 'remove_images', to: 'trips#remove_images', via: [:delete]
    match 'deactivate', to: 'trips#deactivate', via: [:delete]
    collection do
      post 'filter'
    end
  end
  match 'lonelyplanet', to: 'trips#lonelyplanet', via: [:get]
  match 'airports', to: 'trips#airports', via: [:get]

  # facebook omniauth
  match 'auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  match 'auth/failure', to: redirect('/'), via: [:get, :post]
  match 'signout', to: 'sessions#destroy', as: 'signout', via: [:get, :post]
  
  # static pages
  match '/contact_us', to: 'static_pages#contact_us', via: :get
  match '/about', to: 'static_pages#about', via: :get
  # match '/old_about', to: 'static_pages#old_about', via: :get
  match '/how_it_works', to: 'static_pages#how_it_works', via: :get
  match '/privacy', to: 'static_pages#privacy', via: :get
  match '/terms', to: 'static_pages#terms', via: :get
  # match '/press', to: 'static_pages#press', via: :get
  
  resources :relationships, only: [:create, :destroy]
  resources :users, path: "/members" do
    resources :messages
    resources :notifications, only: [:index]
    match 'contacts', to: 'messages#contacts', via: [:get]
    match 'sent_messages', to: 'messages#sent_messages', via: [:get]
    match 'join_requests', to: 'messages#join_requests', via: [:get]
    resources :followings, only: [:create, :destroy]
    resources :verifications, only: [:show]
    match '/resend_verification', to: "verifications#resend", via: :get
    resources :interests
    get 'account'
    get 'photos'
    get 'profile'
    get 'email_settings'
    get 'privacy'
    get 'apps'
    get 'join'
    match 'remove_images', to: 'users#remove_images', via: [:delete]
    match '/trips', to: "trips#user_trips", via: :get
  end
  resources :password_resets, only: [:new, :create, :edit, :update]
  match '/unsubscribe', to: "verifications#unsubscribe", via: :get
  match '/unsubscribed', to: "static_pages#unsubscribed", via: :get
  match '/home', to: "static_pages#home2", via: :get
  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end
  root :to => 'static_pages#home2'
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
