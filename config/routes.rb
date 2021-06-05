Rails.application.routes.draw do
  namespace :api do
    get 'inquiries/create'
  end
  namespace :api do
    resources :inquiries, only: [:create]
  end
end
