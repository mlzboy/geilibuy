class CreateCoupons < ActiveRecord::Migration
  def self.up
    create_table :coupons do |t|
      t.string :name
      t.decimal :money
      t.datetime :start_time
      t.datetime :end_time
      t.integer :user_id
      t.string :status
      t.string :kind
      t.string :code
      t.string :from
      t.decimal :min_money
      t.integer :min_products_num
      t.text :memo

      t.timestamps
    end
  end

  def self.down
    drop_table :coupons
  end
end
