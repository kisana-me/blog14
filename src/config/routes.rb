Rails.application.routes.draw do

  get "health" => "rails/health#show", as: :rails_health_check
  root "others#index"

  scope :secret do
    get 'signup' => 'accounts#signup'
    post 'signup' => 'accounts#create_signup'
    get 'login' => 'accounts#login'
    post 'login' => 'accounts#create_login'
    delete 'logout' => 'accounts#logout'
  end

  resources :accounts, param: :aid, except: [:new, :create]
  resources :images, param: :aid
  resources :posts, param: :aid
  resources :tags, param: :aid

  post 'comment' => 'comments#create'

  # Others
  get 'terms' => 'others#terms'
  get 'policy' => 'others#policy'
  get 'disclaimer' => 'others#disclaimer'
  get 'contact' => 'others#contact'
  post 'contact' => 'others#create_contact'

  # Administorator
  namespace :admin do
    root "studio#index"
  end

  # API
  namespace :v1 do
    post 'images/create' =>  'images#create'
  end
end
