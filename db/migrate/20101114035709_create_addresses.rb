class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.string :consignee
      t.integer :province_id
      t.integer :city_id
      t.integer :district_id
      t.string :address
      t.string :tel
      t.string :mobile
      t.integer :delivery_time_id

      t.timestamps
    end
  end

  def self.down
    drop_table :addresses
  end
end
