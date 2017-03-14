require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations'}
  authenticate :user, ->(u) { u.role == 'admin' } do
    mount Sidekiq::Web => '/sidekiq'
  end

  authenticated :user do
    root 'problems#index', as: :authenticated_root
  end

  devise_scope :user do
    root  "devise/sessions#new"
  end

  namespace :admin do
    resources :users
    resources :companies
    resources :problems
    resources :comments
    root to: 'problems#index', as: :root
  end

  resources :problems do
    member do
      get '/lenses/:lens', to: 'problems#lens', as: :lenses
      get '/review', to: 'problems#review', as: :review
      put '/update_lens', to: 'problems#update_lens', as: :update_lens
      post '/share_by_email', to: 'problems#share_by_email'
      post '/vote', to: 'solution_likes#toggle_like'
    end
  end

  resources :comments, only: [:create, :edit, :update, :destroy]

  resources :users, only: [] do
    member do
      get '/edit_password', to: 'users#edit_password'
      patch '/update_password', to: 'users#update_password'
      patch '/upload_avatar', to: 'users#upload_avatar'
    end
  end

  get '/wizard', to: 'welcome#index', as: :wizard
  get '/profile', to: 'users#profile', as: :profile
end
