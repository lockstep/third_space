Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :admin do
    resources :users
    resources :problems
    resources :comments
    root to: "problems#index"
  end

  root 'welcome#index'
  devise_for :users, controllers: { registrations: 'registrations'}

  resources :problems do
    get '/lenses/:lense', to: 'problems#lense', on: :member, as: :lenses
    get '/success', to: 'problems#success', on: :member, as: :success
    put '/update_lense', to: 'problems#update_lense', on: :member, as: :update_lense
  end
  resources :comments, only: [:create]
  get '/profile', to: 'users#show', as: 'profile'
end
