Rails.application.routes.draw do

  get "health" => "rails/health#show", as: :rails_health_check
  root "posts#index"

  # Accounts
  get 'signup' => 'accounts#signup'
  post 'signup' => 'accounts#create_signup'
  get 'login' => 'accounts#login'
  post 'login' => 'accounts#create_login'
  delete 'logout' => 'accounts#logout'
  get 'a/:name_id' => 'accounts#show', as: 'account'
  get 'a/:name_id/edit' => 'accounts#edit', as: 'edit_account'
  post 'a/:name_id/edit' => 'accounts#update', as: 'update_account'

  # Posts
  get 'p/:post_id' => 'posts#show', as: 'post'
  get 'p' => 'posts#new'
  post 'p' => 'posts#create'
  get 'p/:post_id/edit' => 'posts#edit', as: 'edit_post'
  post 'p/:post_id/edit' => 'posts#update', as: 'update_post'

  # Others
  get 'terms' => 'others#terms'
  get 'policy' => 'others#policy'
  get 'disclaimer' => 'others#disclaimer'
  get 'contact' => 'others#contact'
  post 'contact' => 'others#create_contact'

  # Administorator
  namespace :admin do
    #root 'application#index'
    #get 'accounts'
    #get 'a/:name_id' => 'accounts#show', as: 'account'
    #post 'a/:name_id/update' => 'accounts#update', as: 'update_account'
    #get 'posts'
    #get 'p/:post_id' => 'posts#show', as: 'post'
    #post 'p/:post_id/edit' => 'posts#update', as: 'update_post'
    #get 'others'
  end

  # TODO
  ## Comments
  ## Tags
  ## Categories
  ## API
end
