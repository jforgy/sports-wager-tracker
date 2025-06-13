Rails.application.routes.draw do
  devise_for :users
  root 'wagers#index'
  resources :wagers
end