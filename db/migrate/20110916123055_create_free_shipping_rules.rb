class CreateFreeShippingRules < ActiveRecord::Migration
  def self.up
    create_table :free_shipping_rules do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.string :name
      t.decimal :price,:precision=>15,:scale=>3,:default=>0

      t.timestamps
    end
  end

  def self.down
    drop_table :free_shipping_rules
  end
end
