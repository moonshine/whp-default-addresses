map.resources :users, :has_many => :addresses

# Routes for editing addresses in admin area
map.namespace :admin do |admin|
  admin.resources :users, :has_many => :addresses
end