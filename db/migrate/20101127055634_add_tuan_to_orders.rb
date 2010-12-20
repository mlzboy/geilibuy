class AddTuanToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :tuan, :boolean
  end

  def self.down
    remove_column :orders, :tuan
  end
end
