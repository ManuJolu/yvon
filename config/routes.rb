Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users,
    controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  mount Attachinary::Engine, at: 'attachinary'
  mount Facebook::Messenger::Server, at: 'bot'

  scope '(:locale)', locale: /fr|en/ do
    root to: 'pages#home'
    get '/privacy-policy', to: 'pages#privacy_policy'
    resources :users, only: [:show]
    resources :restaurants, only: [:index, :show, :new, :create, :edit, :update] do
      member do
        patch '/duty/:state' => "restaurants#duty"
      end
      resources :meal_categories, only: [:create, :update], shallow: true
      resources :meals, only: [:index, :new, :create, :edit, :update], shallow: true do
        resources :meal_options, only: [:index], shallow: true
      end
      resources :orders, only: [:index, :update], shallow: true
    end
  end
end
