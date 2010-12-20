class AddUrlToOrderStatuses < ActiveRecord::Migration
  def self.up
    add_column :order_statuses, :url, :string
  end

  def self.down
    remove_column :order_statuses, :url
  end
end
