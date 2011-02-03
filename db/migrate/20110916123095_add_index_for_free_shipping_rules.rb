class AddIndexForFreeShippingRules < ActiveRecord::Migration
  def self.up
	add_index :free_shipping_rules,[:start_time,:end_time]
  end

  def self.down
	remove_index :free_shipping_rules,[:start_time,:end_time]
  end
end
