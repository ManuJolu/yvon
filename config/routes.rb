Rails.application.routes.draw do
  devise_for :users,
    controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  mount Attachinary::Engine, at: 'attachinary'
  mount Facebook::Messenger::Server, at: 'bot'
  root to: 'pages#home'
  resources :users, only: [:show]
  resources :restaurants, only: [:index, :show, :new, :create, :edit, :update] do
    member do
      patch '/duty/:state' => "restaurants#duty"
    end
    resources :meals
    resources :orders, only: [:index, :show, :edit, :update]
  end

end

