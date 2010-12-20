class CreateCashOrderStatuses < ActiveRecord::Migration
  def self.up
    create_table :cash_order_statuses do |t|
      t.integer :cash_order_id
      t.string :name
      t.integer :value,:default=>1

      t.timestamps
    end
  end

  def self.down
    drop_table :cash_order_statuses
  end
end
