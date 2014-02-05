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

  # Grids de Obras (Rodillo de obras)
  get '/admin/works/grid' => 'admin#works_grids', as: "admin_works_grids"

  get '/admin/works/grid/:id' => 'admin#work_grid_edit', as: "admin_work_grid"
  delete '/admin/works/grid/:id' => 'admin#work_grid_delete', as: "admin_delete_work_grid"

  get '/admin/works/grid_element/:id' => 'admin#work_grid_elem_edit', as: "admin_work_gridelement"

  patch "/admin/works/edit_grid_element/:id" => "admin#save_grid_elem", as: "grid_element"

  get "/admin/works/new_grid" => "admin#new_work_grid", as: "admin_new_work_grid"

  # Photos
  # Creando las fotos
  post "/photos" => "photos#create", as: "photos"

  # Form para elegir el display y hacer crops
  get "/work/edit_images" => "works#edit_images", as: "edit_images"

  # Editar el display de una obra
  get "/works/edit_display/:id" => "works#edit_display", as: "edit_display"
  post "/works/save_display/:id" => "works#save_display", as: "save_display"

  # Editar un folder (orden de las fotos y su display)
  get "/works/edit_folder/:id" => "works#edit_folder", as: "edit_folder"
  post "/works/save_folder/:id" => "works#save_folder", as: "save_folder"

  # Editar el videothumb
  get "/works/edit_videothumb/:id" => "works#edit_videothumb", as: "edit_videothumb"
  post "/works/save_videothumb/:id" => "works#save_videothumb", as: "save_videothumb"

  # Obteniendo un folder
  get "/work/image_folder/:id" => "works#image_folder", as: "image_folder"

  # Obteniendo todas las fotos de una obra
  get "/work/images/:id" => "works#images", as: "work_images"

  # Guardando orden
  post "/works/order" => "works#store_order", as: "works_store_order"

  # Obras (Works)
  resources :works

end
