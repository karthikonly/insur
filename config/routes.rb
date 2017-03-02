Rails.application.routes.draw do
  root 'home#index'
  devise_for :users
  resources :provinces
  resources :drags, only: [:new, :edit, :create, :update, :destroy] do
    member do 
      put 'save_and_preview'
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
      get   'new_incident'
      post  'create_incident'
    end
  end
end
