Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'
  resources :problems, only: [:index, :new, :create] do
    get ":id/:page", to: 'problems#show', on: :collection, as: :view
  end

  resources :inputs, only: [:create]

end
