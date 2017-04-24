Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/rails-admin', as: 'rails_admin'
  devise_for :users,
    controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  mount Attachinary::Engine, at: 'attachinary'
  mount Facebook::Messenger::Server, at: 'bot'

  scope '(:locale)', locale: /fr|en/ do
    root to: 'pages#home'
    get '/fooding', to: 'pages#fooding'
    get '/legal', to: 'pages#legal'
    get '/privacy', to: 'pages#privacy'
    resources :users, only: [:show] do
      member do
        patch '/credit_card_update' => 'users#credit_card_update'
        patch '/credit_card_destroy' => 'users#credit_card_destroy'
      end
    end
    resources :restaurants, only: [:index, :new, :create, :edit, :update] do
      member do
        get '/refresh/:update' => 'restaurants#refresh'
        patch '/duty_update/:state' => "restaurants#duty_update"
        patch '/preparation_time_update' => 'restaurants#preparation_time_update'
        get '/facebook_update' => 'restaurants#facebook_update'
        get '/orders/refresh/:order_status' => 'orders#refresh'
      end
      resources :meal_categories, only: [:update], shallow: true
      resources :meals, only: [:index, :new, :create, :edit, :update, :destroy], shallow: true do
        resources :meal_options, only: [:index], shallow: true
      end
      resources :orders, only: [:index, :show, :update], shallow: true do
        resources :payments, only: [:new, :create]
      end
    end
    namespace :admin do
      resources :restaurants, only: [:edit, :update] do
        get '/deliveroo_update' => 'restaurants#deliveroo_update'
        get '/foodora_update' => 'restaurants#foodora_update'
        get '/ubereats_update' => 'restaurants#ubereats_update'
        member do
          get '/messenger_codes' => 'restaurants#messenger_codes'
        end
      end
    end
  end
end
