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

  resources :accounts, param: :name_id, except: [:new, :create]
  resources :images, param: :image_name_id
  resources :posts, param: :post_name_id
  resources :tags, param: :tag_name_id

  post 'comment' => 'comments#create'

  # Others
  get 'terms' => 'others#terms'
  get 'policy' => 'others#policy'
  get 'disclaimer' => 'others#disclaimer'
  get 'contact' => 'others#contact'
  post 'contact' => 'others#create_contact'

  # Administorator
  namespace :admin do
    #
  end

  # API
  namespace :v1 do
    post 'images/create' =>  'images#create'
  end
end
