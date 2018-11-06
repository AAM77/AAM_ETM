Rails.application.routes.draw do

  #root url
  root 'static_pages#home'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/login', to: 'sessions#new'
  post '/sessions/create', to: 'sessions#create'
  delete '/signout', to: 'sessions#destroy'

  # OmniAuth routes
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/failure', to: redirect('/')

  # users routes (nested events and tasks)
  resources :users, except: [:destroy] do
    resources :events, only: [:index, :new, :edit, :show] do #might night even need this
      resources :tasks, only: [:index, :edit, :show] #might not even need this
    end
    member do
      get 'profile'
    end
  end

  delete '/users/:id', to: 'users#destroy', as:'delete_user'

  # nested routes (events) --- do I need this is I have the above? Test out later
  resources :events, except: [:destroy] do
    resources :tasks, only: [:new, :create, :show]
    member do
      get 'show_admin'
    end
  end

  # event routes
  delete '/events/:id', to: 'events#destroy'

  # Not sure how to setup this route with the alias issue. This might be correct. I will see.
  resources :tasks, only: [:index, :edit, :show, :update, :destroy]

  # user_task (participation)
  resources :users_tasks, only: [:create, :destroy] do
    collection do
      patch :user_complete
      patch :admin_complete
    end
  end

  # friendship controlle action routes
  resources :friendships, only: [:create, :destroy]

  # I don't think I am going to use this.
  # But, I might need it if I decide to do use activerecord associations to deal with this
  resources :usersevents, only: [:destroy]
end
