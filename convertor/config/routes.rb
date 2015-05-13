Rails.application.routes.draw do
  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
	
	root 'requests#show'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

	get 'convert' => 'requests#index'
	post 'convert_status' => 'requests#update_status'
	get 'files/download/:hash' => 'requests#download', as: :file_download, constraints: { hash: /[^\/]+/ }

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase
	
  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

	resources :requests
	post 'convert_ready/:file_name' => 'requests#convert_ready', constraints: { file_name: /[^\/]+/ }

	resources :users
	get 'my_requests' => 'users#show_requests', as: :my_requests

  resources :levels
	post 'levels/upgrade/:level' => 'levels#upgrade', as: :level_upgrade

  # converter_api
	scope 'converter_api' do
		post 'login' => 'converter_api#login'
		post 'register'=> 'converter_api#register'
		get 'get_requests/:token/:id' => 'converter_api#get_requests'
		post 'make_request' => 'converter_api#make_request'
    post 'delete_request' => 'converter_api#delete_request'
	end
	#	end 

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
