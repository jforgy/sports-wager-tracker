Rails.application.routes.rb do
  devise_for :users
  root 'wagers#index'
  resources :wagers
end