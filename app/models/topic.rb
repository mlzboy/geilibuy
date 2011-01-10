class Topic < ActiveRecord::Base
  has_many:topic_details
  def details
    TopicDetail.where(:topic_id=>self.id).order("position")
  end
end
