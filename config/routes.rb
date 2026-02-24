# config/routes.rb
Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  
  root "dashboard#index"
  get "dashboard", to: "dashboard#index"
  
  resources :projects do
    resources :bugs
    resources :project_memberships, only: [:index, :create, :update, :destroy]
  end
  
  resources :users, only: [:index, :show, :edit, :update, :destroy]
  
end