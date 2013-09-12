Spree::Core::Engine.routes.draw do
  # Add your extension routes here
  namespace :admin do
  	match '/taxons/load_selection' => 'taxons#load_selection', :format => :json
  end
end
