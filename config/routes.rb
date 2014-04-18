require 'api_constraints'

ApiAccessEvanta::Application.routes.draw do

  # For new version of API example
  # scope module: :v2, constraints: ApiConstraints.new(version: 2) do
  #   resources :notifications, except: [:new, :edit]
  # end

  # devise_scope :user do
  #   post   'users/sign_in' => 'v1/custom_devise/sessions#create' #, :as => :user_session
  #   delete 'users/sign_in', to: 'custom_devise/sessions#destroy', :as => "destroy_user_session"
  #   post   'users/password', to: 'custom_devise/passwords#create', :as => "user_password"
  #   patch  'users/password', to: 'custom_devise/passwords#update', :as => nil
  #   put    'users/password', to: 'custom_devise/passwords#update', :as => nil
  # end

  # devise_for :users, :path => '', :path_names => {
  #   :sign_in => "login",
  #   :sign_out => "logout",
  #   :sign_up => "register"
  # }

  # devise_for :users, :controllers => { :sessions => 'custom_devise/sessions'}, :skip => [:sessions] do
  #   get 'sign_in' => 'custom_devise/sessions#new', :as => :new_user_session
  #   post 'sign_in' => 'custom_devise/sessions#create', :as => :user_session
  # end

  scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do

    # Custome Devise routes
    devise_for :users, path: '/users', controllers: {
      sessions: 'v1/custom_devise/sessions',
      passwords: 'v1/custom_devise/passwords'
    }

    # devise_scope :user do
    #   post   '/users/sign_in'  => 'custom_devise/sessions#create',  as: :user_session
    #   delete '/users/sign_out' => 'custom_devise/sessions#destroy', as: :destroy_user_session

    #   post  '/users/password'  => 'custom_devise/passwords#create', as: :user_password
    #   put   '/users/password'  => 'custom_devise/passwords#update', as: nil
    #   patch '/users/password'  => 'custom_devise/passwords#update', as: nil
    # end
  

    get 'users/profile', to: 'users#show'
    get 'users/profile/:id', to: 'users#show_other_user'
    patch 'users/profile', to: 'users#update'
    put 'users/profile', to: 'users#update'
    get 'users/connections/:user_id', to: 'user_connections#user'
    get 'users/post_options', to: 'users#post_options'
    get 'users/settings', to: 'users#settings'

    post 'group_invites', to: 'group_invites#create'
    delete 'group_invites/:id', to: 'group_invites#destroy'
    get 'group_invites/groups', to: 'group_invites#groups'
    get 'group_invites/users/:group_id', to: 'group_invites#users'
    get 'group_invites/user_search/:group_id', to: 'group_invites#user_search'

    post 'group_requests', to: 'group_requests#create'
    delete 'group_requests/:id', to: 'group_requests#destroy'
    patch 'group_requests/:id', to: 'group_requests#update'
    put 'group_requests/:id', to: 'group_requests#update'
    get 'group_requests/groups', to: 'group_requests#groups'
    get 'group_requests/users/:group_id', to: 'group_requests#users'

    resources :groups, except: [:new, :edit, :destroy]

    resources :event_bookmarks, except: [:new, :edit, :update]
    get '/event_bookmarks/event/:event_id', to: 'event_bookmarks#event_index'

    resources :event_notes, except: [:new, :edit, :index]
    get '/event_notes/event/:event_id', to: 'event_notes#event_index'

    get 'event_session_evaluations/:id', to: 'event_session_evaluations#show'
    get 'event_evaluations/:id', to: 'event_evaluations#show'
    # get 'event_evaluations/event/:event_id', to: 'event_evaluations#event_evaluations'

    get 'app/labels/:page', to: 'app_label_pages#show'

    post 'event_followers', to: 'event_followers#create'
    delete 'event_followers/:id', to: 'event_followers#destroy'
    get 'event_followers/events/:user_id', to: 'event_followers#events'
    get 'event_followers/users/:event_id', to: 'event_followers#users'

    post 'post_followers', to: 'post_followers#create'
    delete 'post_followers/:id', to: 'post_followers#destroy'
    get 'post_followers/posts/:user_id', to: 'post_followers#posts'
    get 'post_followers/users/:post_id', to: 'post_followers#users'

    post 'event_users', to: 'event_users#create'
    delete 'event_users/:event_user_id', to: 'event_users#destroy'
    get 'event_users/events/:user_id', to: 'event_users#events'
    get 'event_users/users/:event_id', to: 'event_users#users'
    get 'event_users/attendees/:event_id', to: 'event_users#attendees'
    get 'event_users/:id', to: 'event_users#show'

    post 'event_user_schedules', to: 'event_user_schedules#create'
    delete 'event_user_schedules/:id', to: 'event_user_schedules#destroy'

    post 'group_members', to: 'group_members#create'
    delete 'group_members/:group_member_id', to: 'group_members#destroy'
    get 'group_members/groups/:user_id', to: 'group_members#groups'
    get 'group_members/users/:group_id', to: 'group_members#users'

    post 'user_connections', to: 'user_connections#create'
    delete 'user_connections/:id', to: 'user_connections#destroy'
    patch 'user_connections/:id', to: 'user_connections#update'
    put 'user_connections/:id', to: 'user_connections#update'
    get 'user_connections/pending', to: 'user_connections#pending'

    # get 'events', to: 'events#index'
    get 'events/all', to: 'events#all'
    get 'events/past', to: 'events#past'
    get 'events/upcoming', to: 'events#upcoming'
    get 'events/:id', to: 'events#show'

    get 'sponsors', to: 'sponsors#index'
    get 'sponsors/app', to: 'sponsors#app'
    get 'sponsors/group', to: 'sponsors#group'
    get 'sponsors/event', to: 'sponsors#event'
    get 'sponsors/:id', to: 'sponsors#show'

    get 'posts/:id', to: 'posts#show'
    get 'posts/user/:user_id', to: 'posts#user_posts'
    get 'posts/group/:group_id', to: 'posts#group_posts'
    get 'posts/event/:event_id', to: 'posts#event_posts'
    post 'posts', to: 'posts#create'
    delete 'posts/:id', to: 'posts#destroy'
    patch 'posts/:id', to: 'posts#update'
    put 'posts/:id', to: 'posts#update'

    post 'post_attachments', to: 'post_attachments#create'
    delete 'post_attachments/:id', to: 'post_attachments#destroy'
    patch 'post_attachments/:id', to: 'post_attachments#update'
    put 'post_attachments/:id', to: 'post_attachments#update'

    resources :featured_posts, only: [:create, :destroy]
    get 'featured_posts/group/:group_id', to: 'featured_posts#group'
    get 'featured_posts/event/:event_id', to: 'featured_posts#event'
    get 'featured_posts/user'

    get 'post_comments/:id', to: 'post_comments#show'
    # get 'post_comments/user/:user_id', to: 'post_comments#user_comments'
    get 'post_comments/post/:post_id', to: 'post_comments#post_comments'
    post 'post_comments', to: 'post_comments#create'
    delete 'post_comments/:id', to: 'post_comments#destroy'
    patch 'post_comments/:id', to: 'post_comments#update'
    put 'post_comments/:id', to: 'post_comments#update'

    resources :post_likes, except: [:new, :edit, :update, :index]
    get 'post_likes/users/:post_id', to: 'post_likes#post_likes'
    get 'post_likes/posts/:user_id', to: 'post_likes#user_likes'

    get 'messages', to: 'messages#index'
    get 'messages/conversation/:user_id', to: 'messages#conversation'
    delete 'messages/conversation/:user_id', to: 'messages#archive_conversation'
    post 'messages', to: 'messages#create'
    delete 'messages/:message_id', to: 'messages#archive'

    get 'navigation/left', to: 'navigation#left'
    get 'navigation/right/:event_id', to: 'navigation#right'

    get 'app_setting_options/:id', to: 'app_setting_options#show'
    get 'app_settings', to: 'app_settings#show'
    delete 'app_settings/:id', to: 'app_settings#destroy'
    post 'app_settings', to: 'app_settings#create'

    get 'event_sessions/:id', to: 'event_sessions#show'
    get 'event_sessions/event/:event_id', to: 'event_sessions#event'
    get 'event_sessions/my_schedule/:event_id', to: 'event_sessions#my_schedule'

    post 'app_supports', to: 'app_supports#create'

    get 'event_speakers/:id', to: 'event_speakers#show'
    get 'event_speakers/event_session/:event_session_id', to: 'event_speakers#show_session_speakers'
    get 'event_speakers/event/:event_id', to: 'event_speakers#show_event_speakers'

    get 'notifications/:id', to: 'notifications#show'
    get 'notifications/user/:user_id', to: 'notifications#user_notifications'

  end

  get 'options_test', to: 'application#cors_preflight_check'
  match '/*path' => 'application#cors_preflight_check', :via => :options


  # devise_for :users
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
