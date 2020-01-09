Rails.application.routes.draw do
  devise_for :users

  root to: 'questions#index'

  resources :questions do
    delete :delete_files, on: :member
    resources :answers, only: %i[create update destroy], shallow: true do
      patch 'set_the_best', on: :member
    end
  end
end
