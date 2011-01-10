class CreateOutOfStocks < ActiveRecord::Migration
  def self.up
    create_table :out_of_stocks do |t|
      t.integer :product_id
      t.integer :user_id
      t.string :contact
      t.string :mobile
      t.string :email
      t.text :message

      t.timestamps
    end
  end

  def self.down
    drop_table :out_of_stocks
  end
end
