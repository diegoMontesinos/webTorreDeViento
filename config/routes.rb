WebTorreDeViento::Application.routes.draw do

  # Devise Auth
  devise_for :users
  
  # Mount CKEditor
  mount Ckeditor::Engine => '/ckeditor'

  # HOME
  root 'home#index'
  get 'home/index' => 'home#index'

  # Guardando orden de los elementos del carousel
  post "/home/carousel/order/:id" => "home#carousel_store_order", as: "carousel_store_order"

  # Mostrando un carousel y home
  get "/home/carousel/:id" => "home#show_carousel", as: "carousel"

  # En construccion
  get "/comming_soon" => "home#comming_soon", as: "comming_soon"

  # ADMINISTRADOR
  get '/admin' => 'admin#show'

  # Administrador (Obras)
  get '/admin/works/new' => 'admin#new_work', as: "admin_new_work"
  get '/admin/works/edit' => 'admin#edit_work', as: "admin_edit_work"
  get '/admin/works' => 'admin#works', as: "admin_works"

  # Administrador (Colaboradores)
  get '/admin/colaborator/new' => 'admin#new_colaborator', as: "admin_new_colaborator"
  get '/admin/colaborator/edit/:id' => 'admin#edit_colaborator', as: "admin_edit_colaborator"
  get '/admin/colaborators' => 'admin#colaborators', as: "admin_colaborators"
  get '/admin/colaborators/home' => 'admin#colaborators_home', as: "admin_colaborators_home"
  get '/admin/colaborators/grid_element/:id' => 'admin#colab_gridelement', as: "admin_colab_gridelement"
  patch '/admin/colaborators/grid_element/:id' => "admin#save_colab_gridelem", as: "colaborator_grid_element"
  post '/admin/colaborators/grid_element/:id' => 'admin#clean_colab_gridelem', as: "colaborator_gridelement_clean"

  # Grids de Obras (Rodillo de obras)
  get '/admin/works/grid' => 'admin#works_grids', as: "admin_works_grids"
  get '/admin/works/grid/:id' => 'admin#work_grid_edit', as: "admin_work_grid"
  delete '/admin/works/grid/:id' => 'admin#work_grid_delete', as: "admin_delete_work_grid"

  get '/admin/works/grid_element/:id' => 'admin#work_grid_elem_edit', as: "admin_work_gridelement"
  post '/admin/works/grid_element/:id' => 'admin#work_grid_elem_clean', as: "admin_work_clean_gridelement"

  patch "/admin/works/edit_grid_element/:id" => "admin#save_grid_elem", as: "grid_element"

  get "/admin/works/new_grid" => "admin#new_work_grid", as: "admin_new_work_grid"

  # Administrador (Carousel home)
  # Admin Home carousel
  get "/admin/home/carousel" => "admin#home_carousel", as: "admin_home_carousel"
  get "/admin/home/new_carousel" => "admin#new_home_carousel", as: "admin_new_home_carousel"
  get "/admin/home/edit_carousel/:id" => "admin#edit_home_carousel", as: "admin_edit_home_carousel"
  delete "/admin/home/carousel/:id" => "admin#delete_home_carousel", as: "admin_delete_home_carousel"

  # Admin Home carousel element
  get "/admin/home/carousel_element/:id" => "admin#carousel_elem_edit", as: "admin_carousel_element"
  patch "/admin/home/carousel_element/:id" => "admin#save_carousel_elem", as: "carousel_element"
  post "/admin/home/carousel_element/:id" => "admin#clean_carousel_elem", as: "clean_carousel_element"

  # Administrador (Nosotros)
  get "/admin/we_are" => "admin#we_are_edit", as: "we_are_edit"
  get "/admin/we_do" => "admin#we_do_edit", as: "we_do_edit"
  get "/admin/list_projects" => "admin#list_projects_edit", as: "list_projects_edit"

  patch "/admin/webinfo/:id" => "admin#webinfo_save", as: "web_info"

  # Photos
  # Creando las fotos
  post "/photos" => "photos#create", as: "photos"

  post "/photos/destroy" => "photos#destroy", as: "destroy_photo"

  # Form para agregar o elminar fotos
  get "/work/edit_folders" => "works#edit_folders", as: "edit_folders"
  post "/work/folders/add_images/:id" => "works#add_images", as: "add_images"

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

  # Obteniendo las imagenes de un folder
  get "/work/image_folder" => "works#images_folder", as: "images_folder"

  # Obteniendo todas las fotos de una obra
  get "/work/images/:id" => "works#images", as: "work_images"

  # Guardando orden
  post "/works/order" => "works#store_order", as: "works_store_order"

  # Obras (Works)
  resources :works

  # Colaboradores (Colaborators)
  
  # Colaboradores Frecuentes
  get "/colaborators/frequents" => "colaborators#frequents", as: "frequents"

  resources :colaborators

  # NOSOTROS

  # Quienes somos
  get "/we_are" => "home#we_are", as: "we_are"

  # Que hacemos
  get "/we_do" => "home#we_do", as: "we_do"

  # Lista de proyectos
  get "/list_projects" => "home#list_projects", as: "list_projects"

  # NOTICIAS
  resources :news

end
