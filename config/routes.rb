Rails.application.routes.draw do
  # get 'categories/index'
  # get 'categories/show'
  # get 'categories/create'
  # get 'categories/edit'
  # resources :products
  devise_for :users, skip: %i[registrations sessions passwords]
  devise_scope :user do
    resources :users,:categories,:items

    post '/signup', to: 'registrations#create'
    post '/login', to: 'sessions#create'
    delete '/logout', to: 'sessions#destroy'

    get '/items-by-user/:id', to: 'items#items_by_user'
    get '/items-by-category/:id', to: 'items#items_by_category'
  end
end