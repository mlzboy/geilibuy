class AddFromToOrderStatuses < ActiveRecord::Migration
  def self.up
    add_column :order_statuses, :from, :string
  end

  def self.down
    remove_column :order_statuses, :from
  end
end
