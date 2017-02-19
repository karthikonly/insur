Rails.application.routes.draw do
  resources :quotes
  resources :provinces
  root 'home#index'
  devise_for :users
end
