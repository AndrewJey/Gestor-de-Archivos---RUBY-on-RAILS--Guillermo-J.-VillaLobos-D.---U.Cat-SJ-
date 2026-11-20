require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users
  root 'videos#index'

  resources :videos do
    member do
      post :like
      post :dislike
      get :like
      get :dislike
    end
  end
  resources :users

  authenticate :user do
    mount Sidekiq::Web => '/sidekiq'
  end
end
