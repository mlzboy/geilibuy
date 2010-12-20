class AddOrderIdToScoreDetails < ActiveRecord::Migration
  def self.up
    add_column :score_details, :order_id, :integer
  end

  def self.down
    remove_column :score_details, :order_id
  end
end
