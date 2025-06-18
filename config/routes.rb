Rails.application.routes.draw do
  devise_for :users
  root 'wagers#index'
  resources :wagers
  
  # CSV Import/Export routes
  resources :wager_imports, only: [:new, :create]
  get 'wager_imports/export', to: 'wager_imports#export'
end