
class OrderSuite < ActiveRecord::Base
  
  has_many:order_suite_products
  
  belongs_to:order
  
  belongs_to:product_show
end
