class RemovePriceToFreeShippingRules < ActiveRecord::Migration
  def self.up
    remove_column :free_shipping_rules, :price
    add_column :free_shipping_rules, :money, :decimal,:default=>0.00,:precision=>15,:scale=>3
  end

  def self.down
    add_column :free_shipping_rules, :price, :decimal
    remove_column :free_shipping_rules, :money
  end
end
