class RemoveScoreToOrders < ActiveRecord::Migration
  def self.up
    remove_column :orders, :score
    remove_column :orders, :s1
    add_column :orders, :cost_scores,:integer,:default=>0
    add_column :orders, :new_scores,:integer,:default=>0
  end

  def self.down
    add_column :orders, :score, :boolean
    add_column :orders, :score, :integer
    remove_column :orders,:cost_scores
    remove_column :orders,:new_scores
  end
end
