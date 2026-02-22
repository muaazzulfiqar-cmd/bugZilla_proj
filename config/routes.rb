Rails.application.routes.draw do

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }  
  
  root "dashboard#index"
  get "dashboard", to: "dashboard#index"
  
  resources :projects do
    resources :bugs
    resources :project_memberships, only: [:index, :create, :update, :destroy]
  end
end