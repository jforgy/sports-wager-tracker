Rails.application.routes.draw do
  devise_for :users
  root 'wagers#index'
  resources :wagers
  get '/health', to: 'health#check'
  get '/test-email', to: 'test#email'
end