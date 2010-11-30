Rails.application.routes.draw do
  resources :users do
    resources :addresses
  end
  # Routes for editing addresses in admin area
  namespace :admin do |admin|
    resources :users do
      resources :addresses
    end
  end
end
