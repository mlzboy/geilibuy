class ArticleCategory < ActiveRecord::Base
  has_many:articles
  acts_as_tree :order=>"position"

  def top_five_articles
    Article.where(:article_category_id=>self.id).order("id desc").limit(5)
  end
end


# == Schema Information
#
# Table name: article_categories
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  position   :integer(4)      default(0)
#  memo       :text
#  created_at :datetime
#  updated_at :datetime
#

