Rails.application.routes.draw do
  root 'home#index'
  get 'home/home_treeview_data'
  get 'home/test_bootstrap'

  resources :components
  resources :file_infos
end
