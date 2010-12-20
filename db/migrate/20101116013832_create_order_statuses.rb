class CreateOrderStatuses < ActiveRecord::Migration
  def self.up
    create_table :order_statuses do |t|
      t.integer :order_id
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :order_statuses
  end
end
