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
    get '/lenses/:lens', to: 'problems#lens', on: :member, as: :lenses
    get '/review', to: 'problems#review', on: :member, as: :review
    put '/update_lens', to: 'problems#update_lens', on: :member, as: :update_lens
  end
  resources :comments, only: [:create, :edit, :update, :destroy]
  resource :users, only: [:show] do
    collection do
      get 'edit_password'
      patch 'update_password'
      patch 'upload_avatar'
    end
  end
end
