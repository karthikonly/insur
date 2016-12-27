Rails.application.routes.draw do
  root 'home#index'
  get 'home/bootstrap'

  resources :components
  resources :file_infos
end
