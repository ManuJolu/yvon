Rails.application.routes.draw do
  devise_for :users,
    controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  mount Attachinary::Engine, at: 'attachinary'
  mount Facebook::Messenger::Server, at: 'bot'
  root to: 'pages#home'
  resources :restaurants, only: [:index, :show, :new, :create, :edit, :update] do
    resources :meals
  end

end

