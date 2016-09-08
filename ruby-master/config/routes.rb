require 'sidekiq/web'
Rails.application.routes.draw do
  devise_for :users
  root 'videos#index'
resources :videos
 resources :users
 get '/videos/:id/like' => 'videos#like'
  get '/videos/:id/dislike' => 'videos#dislike'
  mount Sidekiq::Web => '/sidekiq'
end
