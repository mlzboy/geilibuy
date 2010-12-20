class OrderSuiteProduct < ActiveRecord::Base
  
    belongs_to:order_suite_product
    
    belongs_to:product_show
    
    belongs_to:product
end
