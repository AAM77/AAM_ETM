Rails.application.routes.draw do

  #root url
  root 'static_pages#home'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/login', to: 'sessions#new'
  post '/sessions/create', to: 'sessions#create'
  delete '/signout', to: 'sessions#destroy'

  # usersroutes
  resources :users, except: [:destroy] do
    member do
      get 'profile'
      post 'update_profile'
    end
  end

  delete '/users/:id', to: 'users#destroy', as:'delete_user'


  resources :users, except: [:destroy] do
    resources :events, only: [:index, :new, :edit, :show]
  end

  resources :users, except: [:destroy] do
    resources :tasks, only: [:index, :edit, :show]
  end

  resources :events, except: [:destroy] do
    resources :tasks, only: [:new, :edit, :create, :show]
  end

  # event routes
  resources :events

  # Not sure how to setup this route with the alias issue. This might be correct. I will see.
  resources :tasks, only: [:index, :update, :destroy]

  # user_task (participation)
  resources :users_tasks, only: [:create, :destroy]

end
