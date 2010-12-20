class SetCategoriesPositionColumnDefault < ActiveRecord::Migration
  def self.up
    remove_column  :categories,:position
    add_column  :categories,:position,:integer,:default=>0
  end

  def self.down
    remove_column  :categories,:position
  end
end
