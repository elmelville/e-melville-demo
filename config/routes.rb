Rails.application.routes.draw do

  resources :cached_products
  root :to => 'home#index'
  mount ShopifyApp::Engine, at: '/'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resource 'preferences', only: [:show, :edit, :update]
  match '/preferences/hide_welcome_note' => 'preferences#hide_welcome_note', :via=>[:get, :post]
  match '/preferences/carrier_selected' => 'preferences#carrier_selected', :via=>[:post]

  resources :cached_product do
    collection do
      post :update_all
      post :load_new_products
      get :index
    end
  end    

	match "confirm_charge" => "home#confirm_charge", :via => [:get, :post]
  match "/shipping-rates" => "rates#shipping_rates", :via => :post 

	match '/australia_post_api_connections' => 'australia_post_api_connections#new', :via => :get

  resources 'australia_post_api_connections'

end
