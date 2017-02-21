Rails.application.routes.draw do
  root 'home#index'
  devise_for :users
  resources :provinces
  resources :quotes do
    member do
      get   'new_applicant'
      post  'create_applicant'
    end
  end
end
