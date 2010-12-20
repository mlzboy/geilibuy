class RemoveTuanToOrders < ActiveRecord::Migration
  def self.up
    remove_column :orders, :tuan
  end

  def self.down
    add_column :orders, :tuan, :boolean
  end
end
