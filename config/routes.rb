Rails.application.routes.draw do

  #root url
  root 'static_pages#home'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/login', to: 'sessions#new'
  post '/sessions/create', to: 'sessions#create'
  delete '/signout', to: 'sessions#destroy'

  # usersroutes
  resources :users

  # event routes
  resources :events

  # Not sure how to setup this route with the alias issue. This might be correct. I will see.
  resources :tasks

end
