Rails.application.routes.draw do
  root 'home#index'
  get 'home/treeview_data_json'
  get 'home/pretty_view'
  get 'home/test_bootstrap'

  resources :components
  resources :file_infos
end
