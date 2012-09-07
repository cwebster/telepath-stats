Sweetapp::Application.routes.draw do
  

  resources :ref_sets

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
  
  	match "/statistic/:set_code" => "out_standing_work_index#statistic"
  	match "/paststats/:set_code/:month/:year" => "out_standing_work_index#paststats"
  	match "/paststats/" => "out_standing_work_index#paststats"
  	match "/tatbyday/:set_code/:month/:year" => "out_standing_work_index#tatbyday"
  	match "/tatbyday/" => "out_standing_work_index#tatbyday"
  	match "/outstandingsets" => "out_standing_work_index#outstandingsets"
  	match "/statistics" => "out_standing_work_index#statistics"
  	match "/historical/:set_code/:month/:year" => "out_standing_work_index#historical"
  	match "/historical/" => "out_standing_work_index#historical"
  	match "/amu/" => "amu#outstanding"
  	
  	
     resources :out_standing_work_index do
      member do
         get 'short'
         post 'toggle'
       end
  
       collection do
         get 'gen_xml'
         get 'statistics'
         {:statistic => :get}
#         get 'statistic'
       end
     end

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
  
   
   root :to => "home#index"
   

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
