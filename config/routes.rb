MeiJing::Application.routes.draw do
  
  resources :comments
  
  devise_for :users

  #root to: 'articles#index'
  match '' => redirect('/articles')
  namespace :admin do
    resources :columns
  end

  namespace :admin do
    resources :articles,:path_names => { :new => 'write'} do
      member do
        post :ban
        post :draft
        post :classify
        post :publish
      end

      collection do
        get :drafted
        get :banned
        get :published
        get :search
        post :batch_ban
        post :batch_destroy
        post :batch_draft
        post :batch_classify
        post :batch_publish
      end
    end
    resources :users
    resources :roles
  end

  #scope :module => "admin" do
   # resources :articles, only: [:index, :show]
  #end

  #resources :columns do
   # resources :articles, only: [:index, :show]
  #end

  resources :articles, only: [:index, :show]

  match "/columns/:id/articles", to: "articles#belong_to_column"


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


  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
