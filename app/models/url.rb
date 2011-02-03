class Url < ActiveRecord::Base
  has_many:images
  has_one:product
  
end
