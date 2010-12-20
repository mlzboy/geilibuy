class CommentShow < ActiveRecord::Base
  has_and_belongs_to_many :postsale_comments
end

# == Schema Information
#
# Table name: comment_shows
#
#  id          :integer(4)      not null, primary key
#  category_id :integer(4)
#  name        :string(255)
#  location    :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  memo        :text
#  kind        :string(255)
#

