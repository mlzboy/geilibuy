class CreatePaymentStatuses < ActiveRecord::Migration
  def self.up
    create_table :payment_statuses do |t|
      t.integer :order_id
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :payment_statuses
  end
end
