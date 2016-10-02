Concurrency::Application.routes.draw do

  resources :transfers, only: [:create, :show, :index]

end
