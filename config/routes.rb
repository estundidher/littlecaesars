Rails.application.routes.draw do
  devise_for :customers
  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'

  #home
  get 'shopping/:id',         to: 'home#category', as: :category
  get 'shopping',             to: 'home#shopping', as: :shopping
  get 'contact',              to: 'home#contact',  as: :contact
  get 'shopping/product/:id', to: 'home#product',  as: :product
  get 'pick_up',              to: 'home#pick_up',  as: :pick_up
  get 'about',                to: 'home#about',    as: :about
  get 'menu',                 to: 'home#menu',     as: :menu

  #cart
  get 'cart/add/:product_id',                to: 'cart#modal',      as: :cart_new_item
  post 'cart/add',                           to: 'cart#create',     as: :cart_item_sizables
  post 'cart/add',                           to: 'cart#create',     as: :cart_item_quantitables
  post 'cart/add',                           to: 'cart#create',     as: :cart_item_sizable_additionables
  post 'cart/add',                           to: 'cart#create',     as: :cart_item_splittables
  post 'cart/add',                           to: 'cart#create',     as: :cart_item_additionables
  post 'cart/calculate',                     to: 'cart#calculate',  as: :cart_item_calculate
  delete 'cart/:id',                         to: 'cart#destroy',    as: :cart_remove_item
  get 'cart/:id/checkout',                   to: 'cart#checkout',   as: :cart_checkout
  get '/cart/:mode/:product_id/:side/ingredients', to: 'cart#ingredients',as: :cart_product_items

  #cart toppings
  post '/cart/toppings/calculate',   to: 'cart#toppings_calculate', as: :cart_calulate_toppings
  post '/cart/toppings/add/',        to: 'cart#add_topping', as: :cart_add_topping
  post '/cart/toppings',             to: 'cart#add_toppings', as: :cart_add_toppings
  post '/cart/toppings/open',        to: 'cart#toppings',    as: :cart_toppings

  #cart page
  get 'cart/price',                               to: 'cart#price',    as: :cart_price
  get 'cart(/:product_id)',                       to: 'cart#index',    as: :cart
  post 'cart/mode',                               to: 'cart#mode',     as: :cart_mode
  get 'cart/:mode/:side/:category_id(/:size_id)', to: 'cart#carousel', as: :cart_carousel

  namespace :admin do

    #home
    root 'home#index'
    get 'sign_in', to: 'home#sign_in', as: :sign_in

    resources :sizes
    resources :categories
    resources :product_types
    resources :places
    resources :users
    resources :customers

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
