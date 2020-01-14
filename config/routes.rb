Rails.application.routes.draw do
  devise_for :users

  root to: 'questions#index'

  resources :attachments do
  	delete :delete_files, on: :member
  end	

  resources :questions do
    resources :answers, only: %i[create update destroy], shallow: true do
      patch 'set_the_best', on: :member
    end
  end
end
