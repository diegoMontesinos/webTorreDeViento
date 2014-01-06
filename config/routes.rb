WebTorreDeViento::Application.routes.draw do

  # Devise Auth
  devise_for :users
  
  # Mount CKEditor
  mount Ckeditor::Engine => '/ckeditor'

  # Rutas principales
  root 'home#index'
  get 'home/index' => 'home#index'

  # Administrador
  get '/admin' => 'admin#show'

  # Photos
  # Creando las fotos
  post "/photos" => "photos#create", as: "photos"

  # Obras (Works)
  resources :works

end
