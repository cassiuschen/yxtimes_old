Yxtimes::Application.routes.draw do

  get "feature" => "feature#show", as: "feature"
  get "feature/edit"
  put "feature" => "feature#update", as: "feature"

  resources :votes do
    post "comments" => "comments#create"
    delete "comments/:id" => "comments#destroy", as: "comment"
    post "comments/:comment_id" => "comments#create_subcomment", as: "subcomments"
    delete "comments/:comment_id/:id" => "comments#destroy_subcomment", as: "subcomment"
    post "options" => "comments#votes#vote_for"
  end

  resources :articles do
    post "comments" => "comments#create"
    delete "comments/:id" => "comments#destroy", as: "comment"
    post "comments/:comment_id" => "comments#create_subcomment", as: "subcomments"
    delete "comments/:comment_id/:id" => "comments#destroy_subcomment", as: "subcomment"
  end

  # category
  get "cat:id" => "categories#show", as: "category_show"

  # home controller
  get "home/index"

  # users controller
  get "users/edit"
  put "user" => "users#update"
  get "logout" => "users#logout"
  get "login" => "users#login"


  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
