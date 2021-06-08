Rails.application.routes.draw do
  namespace :api do
    resources :inquiries, only: %i[create index update]
  end
end
