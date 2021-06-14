Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'api/auth'
  namespace :api do
    mount Ahoy::Engine => "/ahoy"
    resources :inquiries, only: %i[create index update] do
      resources :notes, only: :create
    end
  end
end
  