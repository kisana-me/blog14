Rails.application.routes.draw do

  get "health" => "rails/health#show", as: :rails_health_check
  root "others#index"

  scope :secrets do
    get 'signup' => 'accounts#signup'
    post 'signup' => 'accounts#create_signup'
    get 'login' => 'accounts#login'
    post 'login' => 'accounts#create_login'
    delete 'logout' => 'accounts#logout'
  end

  resources :accounts, param: :aid, except: [:new, :create]
  resources :posts, param: :aid
  resources :images, param: :aid
  resources :comments, param: :aid, only: [:create, :update]
  resources :tags, param: :aid

  # Others
  get 'terms' => 'others#terms'
  get 'policy' => 'others#policy'
  get 'disclaimer' => 'others#disclaimer'
  get 'contact' => 'others#contact'
  post 'contact' => 'others#create_contact'

  # Studio
  get 'studio' => 'studio#index'

  # Administorator
  namespace :admin do
    root "studio#index"

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
