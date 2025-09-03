Rails.application.routes.draw do
  root "pages#index"

  # Pages
  get "terms-of-service" => "pages#terms_of_service"
  get "privacy-policy" => "pages#privacy_policy"
  get "contact" => "pages#contact"
  get "sitemap" => "pages#sitemap"

  # Sessions
  get "sessions/start"
  delete "signout" => "sessions#signout"
  resources :sessions, except: [:new, :create], param: :aid

  # Signup
  get "signup" => "signup#new"
  post "signup" => "signup#create"

  # OAuth
  post "oauth" => "oauth#start"
  get "callback" => "oauth#callback"

  resources :accounts, param: :aid, except: [:new, :create]
  resources :posts, param: :aid
  delete 'posts/:aid/thumbnail_variants_delete' => 'posts#thumbnail_variants_delete', as: 'thumbnail_variants_delete'
  resources :images, param: :aid, except: [:destroy]
  get 'images/:aid/variants_show' => 'images#variants_show', as: 'variants_show'
  post 'images/:aid/variants_create' => 'images#variants_create', as: 'variants_create'
  delete 'images/:aid/variants_delete' => 'images#variants_delete', as: 'variants_delete'
  delete 'images/:aid/image_delete' => 'images#image_delete', as: 'image_delete'
  resources :comments, param: :aid, only: [:create, :update]
  resources :tags, param: :aid

  # Studio
  get 'studio' => 'studio#index'

  # Settings
  get "settings" => "settings#index"
  get "settings/account" => "settings#account"
  get "settings/icon" => "settings#icon"
  patch "settings/account" => "settings#post_account"
  delete "settings/leave" => "settings#leave"

  # Administorator
  namespace :admin do
    root 'studio#index'
    get 'export' => 'studio#export'
    resources :accounts, param: :aid, only: [:index, :edit, :update]
    patch 'posts/update_multiple', to: 'posts#update_multiple', as: :update_multiple_posts
    resources :posts, param: :aid, only: [:index, :edit, :update]
    resources :tags, param: :aid, only: [:index]
    resources :inquiries, param: :aid, only: [:index, :show, :update]
  end

  # API
  namespace :v1 do
    post 'images/create' =>  'images#create'
  end

  # Others
  get "up" => "rails/health#show", as: :rails_health_check

  # Errors
  match "*path", to: "application#routing_error", via: :all
end
