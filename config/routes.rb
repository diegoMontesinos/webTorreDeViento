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

  get '/admin/works/new' => 'admin#new_work', as: "admin_new_work"

  get '/admin/works/edit' => 'admin#edit_work', as: "admin_edit_work"

  get '/admin/works' => 'admin#works', as: "admin_works"

  get '/admin/works/grid' => 'admin#works_grids', as: "admin_works_grids"

  get '/admin/works/grid/:id' => 'admin#work_grid_edit', as: "admin_work_grid"

  get '/admin/works/grid_element/:id' => 'admin#work_grid_elem_edit', as: "admin_work_gridelement"

  # Guardando el grid
  patch "/admin/works/edit_grid_element/:id" => "admin#save_grid_elem", as: "grid_element"

  # Photos
  # Creando las fotos
  post "/photos" => "photos#create", as: "photos"

  # Form para elegir el display y hacer crops
  get "/work/edit_images" => "works#edit_images", as: "edit_images"

  # Editar el display de una obra
  post "/works/edit_display/:id" => "works#edit_display", as: "edit_display"

  # Editar un folder (orden de las fotos y su display)
  post "/works/edit_folder/:id" => "works#edit_folder", as: "edit_folder"

  # Editar el videothumb
  post "/works/edit_videothumb/:id" => "works#edit_videothumb", as: "edit_videothumb"

  # Obteniendo un folder
  get "/work/image_folder/:id" => "works#image_folder", as: "image_folder"

  # Obteniendo todas las fotos de una obra
  get "/work/images/:id" => "works#images", as: "work_images"

  # Guardando orden
  post "/works/order" => "works#store_order", as: "works_store_order"

  # Obras (Works)
  resources :works

end
