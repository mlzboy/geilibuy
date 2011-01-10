class TopicDetail < ActiveRecord::Base
  belongs_to:topic
  belongs_to:product_show
end
