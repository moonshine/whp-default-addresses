Rails.application.routes.draw do
  namespace :user do
    resources :addresses
  end
  # Routes for editing addresses in admin area
  namespace :admin do
    resources :users do
      resources :addresses
    end
  end
end
