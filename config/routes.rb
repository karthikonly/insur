Rails.application.routes.draw do
  root 'home#index'

  resources :components
  resources :file_infos
  post 'file_infos/multi_update'
end
