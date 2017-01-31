Rails.application.routes.draw do
  namespace :admin do
    resources :inputs
    resources :users
    resources :problems
    root to: "inputs#index"
  end

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'
  resources :problems, only: [:index, :new, :update, :edit] do
    get ":id/:lens", to: 'problems#show', on: :collection, as: :view
  end

  resources :inputs, only: [:create] do
    get ":problem_id/:lens/:input_type", to: 'inputs#input_text', on: :collection, as: :input_text
    get ":problem_id/count", to: 'inputs#count', on: :collection, as: :input_count
  end

end
