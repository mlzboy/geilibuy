class RemoveScoreToOrderProducts < ActiveRecord::Migration
  def self.up
    remove_column :order_products, :score
    remove_column :order_products, :s1
    add_column :order_products, :cost_scores, :integer,:default=>0
    add_column :order_products, :new_scores, :integer,:default=>0

  end

  def self.down
    add_column :order_products, :score, :boolean
    add_column :order_products, :s1, :integer
    remove_column :order_products, :cost_scores
    remove_column :order_products, :new_scores

  end
end
