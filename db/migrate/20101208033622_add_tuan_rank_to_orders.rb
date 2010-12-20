class AddTuanRankToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :product_rank, :integer,:default=>-2
    add_column :orders, :tuangou, :boolean,:default=>false
    add_column :orders, :delivery_rank, :integer,:default=>-2
    add_column :orders, :package_rank, :integer,:default=>-2
    add_column :orders, :tuan_comment, :text
    add_column :orders, :comment, :text
    add_column :orders, :cash_money,:decimal,:precision=>15,:scale=>3,:default=>0.00
  end

  def self.down
    remove_column :orders, :product_rank
    remove_column :orders, :tuangou
    remove_column :orders, :delivery_rank
    remove_column :orders, :package_rank
    remove_column :orders, :tuan_comment
    remove_column :orders, :comment
    remove_column :orders, :cash_money

  end
end
