Rails.application.routes.draw do
  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'
  get 'gallery', to: 'home#gallery', as: :home_gallery

  namespace :admin do

    root 'home#index'

    resources :sizes
    resources :categories
    resources :product_types
    resources :places
    resources :users

    #products
    get 'products/options', to: 'products#options', as: :products_reload_options
    resources :products

    #prices
    get 'products/:product_id/prices/new', to: 'prices#new', as: :price_new
    resources :prices

    #opening_hours
    get 'places/:place_id/opening_hour/new', to: 'opening_hours#new', as: :opening_hour_new
    get 'opening_hour/shift/add', to: 'opening_hours#add_shift', as: :add_shift
    delete 'opening_hour/shift/:id', to: 'opening_hours#destroy_shift', as: :destroy_shift
    resources :opening_hours

    get 'home', to: 'home#index', as: :home
  end

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
