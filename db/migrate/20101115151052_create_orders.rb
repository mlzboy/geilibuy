class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.integer :user_id
      t.string :sn
      t.string :order_status
      t.string :payment_status
      t.string :ip
      t.string :delivery_status
      t.integer :payment_id
      t.integer :delivery_id
      t.decimal :products_price,:precision => 15, :scale => 3,:default=>0.00
      t.decimal :total_price,:precision => 15, :scale => 3,:default=>0.00
      t.decimal :delivery_price,:precision => 15, :scale => 3,:default=>0.00
      t.integer :products_num,:default=>0
      t.string :consignee
      t.string :province
      t.string :city
      t.string :district
      t.string :address
      t.string :tel
      t.string :mobile
      t.string :delivery_time
      t.string :payment
      t.timestamps
    end
  end

  def self.down
    drop_table :orders
  end
end
