Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :admin do
    resources :users
    resources :companies
    resources :problems
    resources :comments
    root to: "problems#index"
  end

  root 'problems#index'
  devise_for :users, controllers: { registrations: 'registrations'}
  get '/wizard', to: 'welcome#index', as: :wizard

  resources :problems do
    get '/lenses/:lense', to: 'problems#lense', on: :member, as: :lenses
    get '/review', to: 'problems#review', on: :member, as: :review
    put '/update_lense', to: 'problems#update_lense', on: :member, as: :update_lense
  end
  resources :comments, only: [:create]
  resource :users, only: [:show] do
    collection do
      get 'edit_password'
      patch 'update_password'
    end
  end
end
