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

  # Form para elegir el display y hacer crops
  get "/work/edit_images/:id" => "works#edit_images", as: "edit_images"

  # Editar el display de una obra
  post "/works/edit_display/:id" => "works#edit_display", as: "edit_display"

  # Editar un folder (orden de las fotos y su display)
  post "/works/edit_folder/:id" => "works#edit_folder", as: "edit_folder"

  # Obteniendo un folder
  get "/work/image_folder/:id" => "works#image_folder", as: "image_folder"

  # Obras (Works)
  resources :works

end
