Spree::Core::Engine.routes.draw do
  # Add your extension routes here
  namespace :admin do
  	match '/taxon_promotions/load_selection' => 'taxon_promotions#load_selection', :format => :json
  end
end
