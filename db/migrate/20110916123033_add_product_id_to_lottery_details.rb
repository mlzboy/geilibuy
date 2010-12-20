class AddProductIdToLotteryDetails < ActiveRecord::Migration
  def self.up
    add_column :lottery_details, :product_id, :integer
  end

  def self.down
    remove_column :lottery_details, :product_id
  end
end
