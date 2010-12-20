class AddTuanIdToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :tuan_id, :integer
  end

  def self.down
    remove_column :orders, :tuan_id
  end
end
