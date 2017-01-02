Rails.application.routes.draw do
  root 'home#index'
  get 'home/pretty_view'
  get 'home/form_view'
  get 'home/treeview_data_json'

  resources :components
  resources :file_infos
  post 'file_infos/multi_update'
end
