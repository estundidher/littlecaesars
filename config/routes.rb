Rails.application.routes.draw do
  devise_for :customers
  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'

  controller :pick_up do
    get 'pick_up',                 to: :index,  as: :pick_up
    get 'pick_up/:place_id',       to: :when,   as: :pick_up_when
    get 'pick_up/:place_id/:date', to: :times,  as: :pick_up_times
  end

  controller :home do
    get 'order',             to: :order,        as: :order
    get 'contact',           to: :contact,      as: :contact
    post 'contact',          to: :send_message, as: :send_message
    get 'about',             to: :about,        as: :about
    get 'menu(/:active)',    to: :menu,         as: :menu
    get 'order/product/:id', to: :product,      as: :product
  end

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
    get 'home', to: 'home#index', as: :home
    get 'sign_in', to: 'home#sign_in', as: :sign_in

    resources :sizes
    resources :categories
    resources :product_types
    resources :users
    resources :customers
    resources :chefs

    #products
    get 'products/options', to: 'products#options', as: :products_reload_options
    resources :products

    #prices
    get 'products/:product_id/prices/new', to: 'prices#new', as: :price_new
    resources :prices

    resources :places do
      post 'opening_hours(/:opening_hour_id)/shifts/add', to: 'shifts#new', as: :new_opening_hour_shift_add
      patch 'opening_hours/:opening_hour_id/shifts/add', to: 'shifts#new', as: :opening_hour_shift_add
      resources :opening_hours do
        resources :shifts, only: [:destroy, :index]
      end
    end
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