Rails.application.routes.draw do
  #get 'home/index'
  root "home#index"

  #post 'update_array', to: 'home#update_array'
  put 'update_array', to: 'home#update_array'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
