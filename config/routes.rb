Rails.application.routes.draw do
  
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end

  post '/graphql', to: 'graphql#execute'

  api_version(module: 'api/v1', path: { value: 'api/v1' }) do
    get 'session/get_user_token_from_facebook_id' => 'sessions#user_token_from_facebook_id'
    get 'session/get_user_token_from_devise' => 'sessions#user_token_from_devise'

    namespace :reports do
      resources :categories, only: [:index]
      get 'category/:id/sub_categories' => 'sub_categories#index'
    end

    resources :categories, only: [:index]

    resources :lines, only: [] do 
      get 'get', on: :collection
    end

    get 'users' => "users#show"

    resources :sites, only: [:index, :create, :show] do
      get 'stats', on: :member
      get 'pictures', on: :member
      get 'comments', on: :member
      post 'comment' => 'sites#comment', on: :member
      get 'near', on: :collection
      get 'count', on: :collection
      get 'get', on: :collection
      get 'cluster', on: :collection
    end
  end

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks', sessions: 'sessions', registrations: 'registrations' }

  scope '(:locale)', locale: /en|es|fr|dummy/ do

    namespace :moderator do
      get '/' => 'static#index'
      get '/sites/review' => 'sites#review', as: 'sites_review'
      resources :sites, only: [:index, :show, :edit, :update, :destroy]
      resources :zones, only: [:index, :show]
      resources :lines, only: [:index, :create, :show, :edit, :new, :update]
      get '/sites/:id/activate' => 'sites#activate'
      get '/sites/:id/deactivate' => 'sites#deactivate'
    end

    namespace :admin do
      root to: 'static#index'

      get '/import/kml' => 'import#kml'
      post '/import/kml' => 'import#selection'
      put '/import/kml' => 'import#import'
      get '/' => 'static#index'
      get '/config' => 'static#configuration'
      resources :zones
      resources :lines
      get '/sites/review' => 'sites#review'
      resources :sites
      resources :categories
      get '/users' => 'users#index'
      get '/sites/:id/activate' => 'sites#activate'
      get '/sites/:id/deactivate' => 'sites#deactivate'
      get '/sites/:id/remove_custom_icon' => 'sites#remove_custom_icon', as: :site_remove_custom_icon
      resources :users, except: [:new, :create]
      resources :comments
      get '/newsletters/extract_users' => 'newsletters#extract_users'
      get '/newsletters/extract_newsletters' => 'newsletters#extract_newsletters'
      get '/newsletters/extract_users_and_newsletters' => 'newsletters#extract_users_and_newsletters'
      resources :newsletters

      namespace :reports do
        resources :reports
        resources :categories
        resources :sub_categories
        resources :statuses
        
        put '/reports/:id/update_status' => 'reports#update_status'
      end

    end

    resources :rides
    resource 'profile'
    post '/profile/link_to_facebook_profile' => 'profiles#link_to_facebook_profile'
    delete '/profile/unlink_facebook_profile/:token' => 'profiles#unlink_facebook_profile'

    patch '/sites/:id/rate' => 'sites#rate'
    patch '/sites/:id/comment' => 'sites#comment'

    get '/sites/' => 'sites#show', as: 'show_site'
    resources :reports, only: [:show, :new, :create, :index]
    resources :sites, only: [:show, :new, :create, :index]
    resources :categories, only: :show

    get '/tos' => 'static#tos'
    get '/team' => 'static#team'
    get '/press' => 'static#press'
    get '/ranking' => 'static#ranking'

    get '/newsletters/unsubscribe/:email' => 'newsletters#unsubscribe'
    delete '/newsletters/unsubscribe/:email' => 'newsletters#destroy'


    resources :newsletters

    root to: 'static#index'
  end

  match '/api' => 'static#api', via: :all
  post '/agregar' => 'static#agregar'

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
