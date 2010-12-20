class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.string :name
      t.text :memo
      t.integer :parent_id
      t.integer :position,:default=>0
      t.timestamps
    end
  end

  def self.down
    drop_table :payments
  end
end
