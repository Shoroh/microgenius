Microgenius::Application.routes.draw do
  root 'posts#index'

  concern :pageable do
    get 'page/:page', :action => :index, :on => :collection
  end

  controller :sessions do
    post 'login' => :create
    delete 'logout' => :destroy
  end

  #resources :users # Перекрываем пути к юзерам.

  resources :posts, path: 'blog', concerns: :pageable
  resource 'tags/:tag', to: 'posts#index', as: :tag, concerns: :pageable

  get 'travel/', to: 'posts#index_travel'

  get 'draft/', to: 'posts#index_draft'
  get 'date/:year/(:month)', to: 'posts#index_by_date'
  post 'retina/', to: 'posts#retina'

  get 'map/', to: 'posts#map_finder'


  mount Ckeditor::Engine => '/ckeditor'

end
