Rails.application.routes.draw do
  namespace :api do
    resources :inquiries, only: [:create, :index]
  end
end
