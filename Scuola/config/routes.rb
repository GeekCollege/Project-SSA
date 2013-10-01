Scuola::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  
  root :to => 'home#dash'
  get '/home/login' => 'home#login' , :as => 'login'
  get '/home/register' => 'home#register' , :as => 'register'
  post '/home/login' => 'home#verify' , :as => 'login_verify'
  post '/home/register' => 'home#newuser' , :as => 'register_submit'
  get '/home(/u/:uid)' => 'home#index' , :as => 'home_index' # user_selfindex

  #messages

  get '/home/messages' => 'home#messages_list' , :as => 'home_messages_list'
  get '/home/messages/count' =>  'home#messages_count' , :as => 'home_messages_count'
  post '/home/message/send' => 'home#message_send' , :as => 'home_message_send'
  get '/home/message/:mid' => 'home#message' , :as => 'home_message'  ,:constraints => {:mid => /\d+/}
  #site
  get '/site/tos' => 'site#tos' , :as => 'tos'
  get '/site/donate' => 'site#donate' , :as => 'donate'
  get '/site/aboutus' => 'site#aboutus' , :as => 'aboutus'
  get '/site/privacy' => 'site#privacy' , :as => 'privacy'

  #before
  get '/home/center' => 'home#center' , :as => 'home_center' # user_setting ( * require login * )

  get '/home/logout' => 'home#logout' , :as => 'home_logout'
 # get '/home/r/resend' => "home#rresend" , :as => 'home_verifyRresend'
  match '/course(/:page(/:tag))' , :to=>'course#index' , :as => 'course_list'  , :via => "get"
  get '/forum' => 'forum#index', :as => 'forum'
  
  #oauth

  get '/oauth/client/:provider/:act' => "oauth#clientcall" , :as => "oauth_client"
  get '/oauth/client/:provider/:act/callback' => "oauth#clientcallback" , :as => "oauth_client_callback"

  namespace :forum do
    # post

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
