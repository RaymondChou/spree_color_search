Spree::Core::Engine.routes.draw do
  # Add your extension routes here
  get '/colors/(:hex)', :to => 'colors#index'
end
