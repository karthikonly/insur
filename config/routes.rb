Rails.application.routes.draw do
  root 'home#index'
  devise_for :users
  resources :provinces
  resources :quotes do
    member do
      get   'new_applicant'
      post  'create_applicant'
      get   'new_driver'
      post  'create_driver'
    end
  end
end
