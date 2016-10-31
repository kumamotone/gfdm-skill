SampleApp::Application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users,
             controllers: {registratoins: 'registratoins'}
  resources :skills, except: [:index]
  resources :musics do
    collection do
      get 'hot'
      get 'other'
    end
  end
  match '/users/old', to: 'users#index_old', via: 'get'
  resources :users do
    member do
      get 'drum'
      get 'guitar'
      get 'manage'
      post 'import'
    end
  end
  resources :sessions, only: [:new, :create, :destroy]
  root 'static_pages#home'
  match '/update_maxuser', to: 'skills#update_maxuser', via: 'get'
  match '/api/userlist', to: 'users#userlist', via: 'get'
  #match '/signup',  to: 'users#new',            via: 'get'
  #match '/signin',  to: 'sessions#new',         via: 'get'
  #match '/signout', to: 'sessions#destroy',     via: 'delete'
  #post ':controller(/:action(/:id(.:format)))'
  #get ':controller(/:action(/:id(.:format)))'
  devise_scope :user do
    match '/sessions/new.user', to: 'devise/sessions#new', via: :get
    match '/sessions/user', to: 'devise/sessions#create', via: :post
  end

  match '/average' => 'static_pages#average', via: :get
  match '/average/drum/other/:from/:to' => 'users#drum_average_other', via: :get
  match '/average/drum/hot/:from/:to' => 'users#drum_average_hot', via: :get
  match '/average/guitar/other/:from/:to' => 'users#guitar_average_other', via: :get
  match '/average/guitar/hot/:from/:to' => 'users#guitar_average_hot', via: :get
  # match '/average/guitar/:from/:to' => 'users#guitar_average', via: get
  # match '/help',    to: 'static_pages#help',    via: 'get'
  # match '/about',   to: 'static_pages#about',   via: 'get'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
