class AddUserIdToOrderProducts < ActiveRecord::Migration
  def self.up
    add_column :order_products, :user_id, :integer
  end

  def self.down
    remove_column :order_products, :user_id
  end
end
