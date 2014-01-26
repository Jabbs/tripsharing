require 'sidekiq/web'
Tripsharing::Application.routes.draw do
  # facebook omniauth
  match 'auth/:provider/callback', to: 'sessions#create'
  match 'auth/failure', to: redirect('/')
  match 'signout', to: 'sessions#destroy', as: 'signout'
  
  # static pages
  match '/about', to: 'static_pages#about', via: :get
  match '/how_it_works', to: 'static_pages#how_it_works', via: :get
  match '/privacy', to: 'static_pages#privacy', via: :get
  match '/terms', to: 'static_pages#terms', via: :get
  match '/press', to: 'static_pages#press', via: :get
  
  resources :users do
    resources :verifications, only: [:show]
    match '/resend_verification', to: "verifications#resend", via: :get
  end
  resources :password_resets, only: [:new, :create, :edit, :update]
  match '/unsubscribe', to: "verifications#unsubscribe", via: :get
  match '/unsubscribed', to: "static_pages#unsubscribed", via: :get
  match '/home', to: "users#home", via: :get
  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end
  root :to => 'users#home'
  mount Sidekiq::Web, at: '/sidekiq'
end
