class CreateCashDetails < ActiveRecord::Migration
  def self.up
    create_table :cash_details do |t|
      t.integer :user_id
      t.decimal :money,:precision=>15,:scale=>3,:default=>0.00
      t.text :memo
      t.boolean :cost
      t.boolean :tougou,:default=>false

      t.timestamps
    end
  end

  def self.down
    drop_table :cash_details
  end
end
