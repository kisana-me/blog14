Rails.application.routes.draw do

  get "health" => "rails/health#show", as: :rails_health_check
  root "pages#index"

  scope :secrets do
    get '/' => 'pages#secrets'
    post '/'=> 'pages#secrets_check', as: 'secrets_check'
    post 'signup' => 'accounts#create_signup'
    post 'login' => 'accounts#create_login'
    delete 'logout' => 'accounts#logout'
  end

  resources :accounts, param: :aid, except: [:new, :create]
  resources :session, params: :aid, only: []
  resources :posts, param: :aid
  delete 'posts/:aid/thumbnail_variants_delete' => 'posts#thumbnail_variants_delete', as: 'thumbnail_variants_delete'
  resources :images, param: :aid, except: [:delete]
  get 'images/:aid/variants_show' => 'images#variants_show', as: 'variants_show'
  post 'images/:aid/variants_create' => 'images#variants_create', as: 'variants_create'
  delete 'images/:aid/variants_delete' => 'images#variants_delete', as: 'variants_delete'
  delete 'images/:aid/image_delete' => 'images#image_delete', as: 'image_delete'
  resources :comments, param: :aid, only: [:create, :update]
  resources :tags, param: :aid

  # Pages
  get 'terms' => 'pages#terms'
  get 'privacy' => 'pages#privacy'
  get 'sitemap' => 'pages#sitemap'
  get 'contact' => 'pages#contact'
  post 'contact' => 'pages#create_contact'

  # Studio
  get 'studio' => 'studio#index'

  # Administorator
  namespace :admin do
    root 'studio#index'

    resources :accounts, param: :aid, only: [:index, :edit, :update]
    patch 'posts/update_multiple', to: 'posts#update_multiple', as: :update_multiple_posts
    resources :posts, param: :aid, only: [:index, :edit, :update]
    resources :inquiries, param: :aid, only: [:index, :show, :update]
  end

  # API
  namespace :v1 do
    post 'images/create' =>  'images#create'
  end

  # Error
  get '*not_found', to: 'application#routing_error'
  post '*not_found', to: 'application#routing_error'
end
