B2c2::Application.routes.draw do

  match "alipay/respond"=>"alipay#return_url_process"
  match "alipay/notify"=>"alipay#notify_url_process"
  match "tenpay/respond"=>"tenpay#return_url_process"
  get "topic/:topic_id"=>"home#topic"
  get "map"=>"home#map"
  get "score"=>"home#score"
  get "point"=>"home#score"
  get "points"=>"home#score"
  
  get "score_exchange"=>"home#score_exchange"
  get 'vote' =>"home#vote"

  match "helpcenter/:article_id"=>"home#helpcenter"
  match "about/:article_id"=>"home#about"
  match "advice"=>"home#advice"
  
  match "consulting_reply"=>"home#consulting_reply"
  match "coupon_send"=>"home#coupon_send"
  match "festival_promotion"=>"home#festival_promotion"
  match "find_password"=>"home#find_password"
  match "order_confirm"=>"home#order_confirm"
  match "order_send"=>"home#order_send"
  match "product_arrival"=>"home#product_arrival"
  match "convert"=>"home#convert"
  match "suite/:suite_id"=>"home#suite"
  match "cod_area"=>"home#cod_area"
  match "share"=>"home#share"
scope "tuan" do
  match "alipay/respond"=>"alipay#tuan_return_url_process"
  match "alipay/notify"=>"alipay#tuan_notify_url_process"
  match "tenpay/respond"=>"tenpay#tuan_return_url_process"
  match "r:user_id"=>"return#tuan_return_money"
  get "order" =>"tuan_shopping#order"
  match "payment"=>"tuan_shopping#payment"
  match "checkout"=>"tuan_shopping#checkout"
  get "pay_success/:sn"=>"tuan_shopping#pay_success"
  get "pay_failure/:sn"=>"tuan_shopping#pay_failure"
  match "order_detail/:sn"=>"account#order_detail"
  match "order_cancle/:sn"=>"account#order_cancle"
  match "cash_pay_success/:sn",:to=>"account#cash_pay_success"
  match "cash_pay_failure/:sn",:to=>"account#cash_pay_failure"
  resources :account do
    collection do
      get :register
      get :login
      get :regok
      match :address
      match :address_edit
      match :address_delete
      match :use_this_address
      match :orders
      match :settings
      match :credit
      match :invites
      match :points
      match :charge
      match :chargepay
      match :pay
      match :pay_jump
      match "alipay/respond"=>"alipay#tuan_cash_return_url_process"
      match "alipay/notify"=>"alipay#tuan_cash_notify_url_process"
      match "tenpay/respond"=>"tenpay#tuan_cash_return_url_process"
      match "share"=>"tuan#share"
    end
  end
end

resources :tuan do
  collection do
    match :check
    get :index
    get :faq
    match "help/faq" => "tuan#faq"
    get :deals
    get "deals/:yyyymmdd"=>'tuan#index',:constraints => {:yyyymmdd=>/\d+/}
    match :qa
    match "qa/:yyyymmdd"=>'tuan#qa',:constraints => {:yyyymmdd=>/\d+/}
    get "about/:about_id"=> "tuan#about"#给力团公告
    get "article/:article_id"=>"tuan#article"
    get :guide
    match :subscribe
    match :share
    match :unsubscribe
    match :everyday
    match :order_confirm
    match :order_send
  end
end

  #get "tuan/about/:about_id"=> "tuan#about"
  #get "tuan" => "tuan#index"
  #get "tuan/index"
  #
  #get "tuan/register"
  #
  #get "tuan/login"
  #
  #get "tuan/faq"
  #
  #get "tuan/deals"
  #
  #get "tuan/order"
  #
  #get "tuan/checkout"
  #
  #get "tuan/payment"

  get 'kindeditor/images_list'

  post 'kindeditor/upload'

match '/shopping' =>'shopping#cart'
resources :shopping do
  collection do
    match :update_cart
    match :update_cart4suite
    match :check
    match :cart
    match :checkout
    match :region
    match :address_list
    match 'order_success/:sn' =>'shopping#order_success'
  end
end
#scope :module => "helpcenter" do
#  resources :test do
#    collection do
#      get 'go'
#    end
#  end
#end

#scope "helpcenter" do
#  get "hh/logout"
#end
#
#  get "helpcenter/logout"
##namespace :helpcenter do
##  get "hh/logout"
##end
  get 'cc/index'
  match 'pay_failure'=>"shopping#pay_failure"
  match 'pay_success'=>"shopping#pay_success"
  get "product/:product_id"=>"home#product_detail"
  get 'home/product_detail'
  match "lottery/r:user_id"=>"return#lottery_return_scores",:constraints => {:user_id=>/\d+/}
  match "lottery"=>"home#lottery"
  match "lottery_list"=>"home#lottery_list"
  #match "sub_category/:categoryid"=>'home#sub_category'
  match "brands"=>"home#brands"
  match "brands/:brand_id"=>"home#brand"
  match "article_list/:article_category_id"=>"home#article_list"
  match "article_list"=>"home#article_list"
  match "article/:article_id"=>"home#article"
  match "search" => "home#search"
  match "category/:categoryid" =>'home#category'
  match '/new' => 'home#new'
  match '/gift' =>"home#gift"
  match '/gift/:categoryid' => "home#gift"
  match '/promotion' => 'home#promotion'
  match '/presale_consultings' =>'home#presale_consultings'
  match '/postsale_comments' =>'home#postsale_comments'
  #match 'usercenter' =>'usercenter#index'
  resources :usercenter do
    collection do
      match :register
      match :login
      match :logout
      match :check
      get :active
      match :address
      match :order_list
      match "order_detail/:sn" => 'usercenter#order_detail'
      match "welcome" =>'usercenter#index'
      match :favorites
      match :bought_products
      match "order_cancle/:id"=>'usercenter#order_cancle'
      match :profile
      match :mod_password
      match :postsale_comments
      match :presale_consultings
      match "upload_photos/:product_id"=>'usercenter#specific_upload_photo_list'
      match "upload_photos/:product_id/new"=>'usercenter#upload_new_photo'
      match "postsale_comments/:product_id/new"=>'usercenter#new_postsale_comment'
      match :upload_photos
      match "upload_photo/:upload_photo_id"=>'usercenter#upload_photo'
      match :account
      match :exchange
      match :vipcard
      match :coupons
      match :scores
      match :invites
      match :forgot
      match :change_password_by_email
      match :out_of_stock
      match "out_of_stock/:product_id/new" => "usercenter#new_out_of_stock"
      match "out_of_stock/:out_of_stock_id/new" => "usercenter#del_out_of_stock"

    end
  end
  #get "usercenter/login"

  #get "usercenter/logout"
  #get "usercenter/register"

  #namespace :usercenter do
  #  resources :users do
  #    #member do
  #    #  get 'following', 'followers'
  #    #  post 'follow'
  #    #end
  #    collection do
  #      get  'login'
  #    end
  #  end
  #end

  #namespace :admin do resources :slots end

  match "category_test/index" =>'admin/category_test#index'


  resources :presale_consultings
  namespace :admin do

    match 'categories/:id/sub' => 'categories#sub'
    match 'categories/:parent_id/new' => 'categories#sub_new'
    match 'categories/ajax_ids2/:id' =>'categories#ajax_ids2'
    #match 'categories/ajax_ids/:id' =>'categories#ajax_ids'
    match 'categories/ajax_sub' =>'categories#ajax_sub'
    match 'categories/all' => 'categories#all'
    match 'categories/:id/sub' => 'categories#sub'
    match 'categories/:parent_id/new' => 'categories#sub_new'
    resources :categories
    match 'products/list' => "products#list"
    match '/products/search' =>'products#index'
    match '/products/batch_select' =>'products#batch_select'
    resources :products


    #resources :gifts
    #match 'gifts/:id/sub' => 'gifts#sub'
    #match 'gifts/:parent_id/new' => 'gifts#sub_new'

    resources :presale_consultings
    resources :postsale_comments
    match 'brands/batch_select' => "brands#batch_select"
    match 'brands/ajax_ids/:id' =>'brands#ajax_ids'
    match 'brands/ajax_get_brands_by_category_id' =>'brands#ajax_get_brands_by_category_id'
    resources :brands

    resources :crops
    match 'crops/update', :to => 'crops#update'
    match 'crops/restore', :to => 'crops#restore'

    resources :slots
    match '/materials/query' =>'slots#query'
    resources :materials
    match '/products/query' =>'product_shows#query'
    match "product_shows/batch_select" => 'product_shows#batch_select'
    match "product_shows/delete_belongs_product/:product_show_id/:product_id" => 'product_shows#delete_belongs_product'
    resources :product_shows
    resources :comment_shows
    resources :delivery_times
    match 'payments/:id/sub' => 'payments#sub'
    resources :payments
    resources :deliveries
    resources :articles
    resources :article_categories
    resources :tuans
    resources :qas
    match 'votes/:id/sub' => 'votes#sub'
    resources :votes
    resources :coupons

    resources :orders
    resources :educations
    resources :jobs
    resources :score_details
    resources :delivery_companies
    resources :lotteries
    resources :lottery_details
    resources :advices
    resources :free_shipping_rules
    resources :topics
    resources :out_of_stocks
  end

  #namespace :usercenter do
  #  #resources :presale_consultings
  #  #resources :postsale_comments
  #
  #  match "upload_photos/:product_id/new"=>'usercenter#upload_new_photo'
  #  match "postsale_comments/:product_id/new"=>'usercenter#new_postsale_comment'
  #end

  #resources :homes
  root :to => 'home#index'





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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end

