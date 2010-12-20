class AddDispatchScoreToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :dispatch_scores, :boolean,:default=>false
  end

  def self.down
    remove_column :orders, :dispatch_scores
  end
end
