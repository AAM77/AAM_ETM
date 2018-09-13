Rails.application.routes.draw do

  #root url
  get '/', to: 'welcome#home'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  # usersroutes
  resources :users

  # event routes
  resources :events

  # Not sure how to setup this route with the alias issue. This might be correct. I will see.
  resources :tasks

end
