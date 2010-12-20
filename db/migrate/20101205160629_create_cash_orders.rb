class CreateCashOrders < ActiveRecord::Migration
  def self.up
    create_table :cash_orders do |t|
      t.string :sn
      t.integer :user_id
      t.boolean :tuangou,:default=>false
      t.integer :payment_id
      t.string :ip
      t.decimal :money,:percision=>15,:scale=>3
      t.string :payment_name
      t.integer :new_scores,:default=>0

      t.timestamps
    end
  end

  def self.down
    drop_table :cash_orders
  end
end
