class Article < ActiveRecord::Base
  belongs_to:article_category
end

# == Schema Information
#
# Table name: articles
#
#  id                  :integer(4)      not null, primary key
#  title               :string(255)
#  content             :text
#  created_at          :datetime
#  updated_at          :datetime
#  article_category_id :integer(4)
#

