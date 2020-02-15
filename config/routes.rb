Rails.application.routes.draw do
  devise_for :users

  root to: 'questions#index'

  concern :votable do
    post :like, on: :member
    post :dislike, on: :member
  end

  resources :questions, concerns: [:votable] do
    resources :answers, concerns: [:votable], only: %i[create update destroy], shallow: true do
      patch 'set_the_best', on: :member
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :gifts, only: :index
end
