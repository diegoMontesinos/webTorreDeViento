WebTorreDeViento::Application.routes.draw do
  
  devise_for :users


  # Rutas principales
  root 'home#index'
  get 'home/index' => 'home#index'

  # Administrador
  get '/admin' => 'admin#show'

  # Obras (Works)
  resources :works
  
end
