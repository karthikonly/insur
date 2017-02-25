Rails.application.routes.draw do
  resources :drags
  root 'home#index'
  devise_for :users
  resources :provinces, only: [:new, :edit, :create, :update, :destroy] do
    member do 
      post 'save_and_preview'
    end
  end
  resources :quotes do
    member do
      get   'new_applicant'
      post  'create_applicant'
      get   'new_driver'
      post  'create_driver'
      get   'new_insur_vehicle'
      post  'create_insur_vehicle'
    end
  end
end
