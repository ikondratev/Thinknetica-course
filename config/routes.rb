require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  root to: 'questions#index'

  concern :votable do
    post :like, on: :member
    post :dislike, on: :member
  end

  concern :commentable do
    resources :comments, only: :create
  end

  resources :questions, concerns: %i[votable commentable], shallow: true do
    member do
      post :subscribe
      delete :unsubscribe
    end
    resource :subscription, only: %i[create destroy]
    resources :comments, only: :create
    resources :answers, concerns: %i[votable commentable], only: %i[create update destroy] do
      patch 'set_the_best', on: :member
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :gifts, only: :index

  mount ActionCable.server => '/cable'

  resources :authorizations, only: %i[new create]

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [] do
        get :me, on: :collection
        get :index, on: :collection
      end

      resources :questions, shallow: true do
        resources :answers
      end
    end
  end
end
