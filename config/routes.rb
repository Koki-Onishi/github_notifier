Rails.application.routes.draw do
  get 'sessions/new'
  root to: 'top#show'
  get 'sign_up', to: 'users#new'
  get 'edit', to:'top#edit'
  post  'edit', to:'user#update'
  get 'log_in', to: 'sessions#new'
  post 'log_in', to: 'sessions#create'
  get 'log_out', to: 'sessions#destroy'
  resources :users
  post 'new_issues', to: 'top#new_issues'
end
