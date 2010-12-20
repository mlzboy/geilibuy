class AddCashOrderIdToScoreDetails < ActiveRecord::Migration
  def self.up
    add_column :score_details, :cash_order_id, :integer
  end

  def self.down
    remove_column :score_details, :cash_order_id
  end
end
