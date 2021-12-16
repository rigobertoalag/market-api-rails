Rails.application.routes.draw do
  # resources :products
  devise_for :users, skip: %i[registrations sessions passwords]
  devise_scope :user do
    post '/signup', to: 'registrations#create'
    post '/login', to: 'sessions#create'
    delete '/logout', to: 'sessions#destroy'
    resources :users,:items
    get '/items-by-user/:id', to: 'items#items_by_user'
  end
end