class PostsaleComment < ActiveRecord::Base
    has_and_belongs_to_many :comment_shows
    belongs_to:product
    belongs_to:user
end

# == Schema Information
#
# Table name: postsale_comments
#
#  id         :integer(4)      not null, primary key
#  content    :text
#  reply      :text
#  ip         :string(255)
#  product_id :integer(4)
#  user_id    :integer(4)
#  created_at :datetime
#  updated_at :datetime
#  hide       :boolean(1)      default(FALSE)
#  creative   :integer(4)      default(0)
#  feature    :integer(4)      default(0)
#  quality    :integer(4)      default(0)
#  value      :boolean(1)      default(FALSE)
#

