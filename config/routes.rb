Rails.application.routes.draw do
  resources :provinces
  root 'home#index'
  devise_for :users
end
