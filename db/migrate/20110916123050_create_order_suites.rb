class CreateOrderSuites < ActiveRecord::Migration
  def self.up
    create_table :order_suites do |t|
      t.string :name
      t.integer :num
      t.decimal :suite_price,:precision=>15,:scale=>3,:default=>0.00
      t.integer :suite_num,:integer
     
      t.timestamps
      t.integer :product_show_id
      t.integer :order_id
    end
  end

  def self.down
    drop_table :order_suites
  end
end
