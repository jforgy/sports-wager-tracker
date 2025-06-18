Rails.application.routes.draw do
  devise_for :users
  root 'wagers#index'
  resources :wagers

  get 'csv/import', to: 'csv#import_form', as: 'csv_import_form'
  post 'csv/import', to: 'csv#import', as: 'csv_import'
  get 'csv/export', to: 'csv#export', as: 'csv_export'
end