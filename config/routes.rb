Rails.application.routes.draw do
  devise_for :users
  use_doorkeeper
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

  root "home#new"

  resources :home do
    post "add_signup" => "home#add_signup"
  end

  namespace :api do

    get 'userchallenges/:id' => 'users#user_challenges', as: :users

    get 'showInviteWithChallengeName' => 'invites#showInviteWithChallengeName', as: :invites
    get 'showAcceptedChallenges/:id' => 'invites#showAcceptedChallenges'
    get 'friendRequests' => 'friends#friendRequests'
    get 'friends/:id' => 'friends#friends'
    delete 'enterpriceapp/getridofroomphoto/:id' => 'friends#getridofroomphoto'
    get 'followRequest' => 'followers#followRequest'
    get 'followers/:id' => 'followers#followers'
    get 'follows/:id' => 'followers#follows'
    post 'challenges/create_with_receivers' => 'challenges#create_with_receivers'
    get 'showAllActionForUser' => 'completes#showAllActionForUser'
    get 'showAllActionsForInvite/:id' => 'completes#showAllActionsForInvite'
    get 'challengeprocess' => 'completes#challengeprocess'
    get 'search_users/:key' => 'users#search_users'
    get 'user_stats/:id' => 'users#user_stats'
    get 'news/:id' => 'users#news'
    get 'get_activities' => 'activities#get_activities'
    post 'upload_profile_image/:id' => 'users#upload_profile_image'
    post 'upload_cover_image/:id' => 'users#upload_cover_image'
    get 'remove_profile_image/:id' => 'users#remove_profile_image'
    get 'remove_cover_image/:id' => 'users#remove_cover_image'

    get 'profile_image_medium_url/:id' => 'users#profile_image_medium_url'
    get 'cover_image_medium_url/:id' => 'users#cover_image_medium_url'
    get 'show_friends/:id' => 'friends#show_friends'

    resources :invites
    resources :completes
    resources :friends
    resources :followers
    #resources :home
    resources :users do
      resources :challenges do
        resources :tasks do
         resources :actions do
          resources :task_dates
         end
        end
      end
    end
    resources :invites
  end

end
