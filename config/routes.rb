Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  resources :restaurants, only: [:index, :show, :new, :create, :edit, :update]
end
