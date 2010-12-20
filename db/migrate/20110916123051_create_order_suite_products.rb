class CreateOrderSuiteProducts < ActiveRecord::Migration
  def self.up
    create_table :order_suite_products do |t|
      t.integer :product_show_id
      t.integer :order_suite_id
      t.integer :product_id

      t.timestamps
    end
  end

  def self.down
    drop_table :order_suite_products
  end
end
