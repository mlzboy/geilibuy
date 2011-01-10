class AddOnToTopics < ActiveRecord::Migration
  def self.up
    add_column :topics, :on, :boolean,:default=>true
  end

  def self.down
    remove_column :topics, :on
  end
end
