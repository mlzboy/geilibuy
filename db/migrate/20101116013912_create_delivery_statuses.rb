class CreateDeliveryStatuses < ActiveRecord::Migration
  def self.up
    create_table :delivery_statuses do |t|
      t.integer :order_id
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :delivery_statuses
  end
end
