class CreateDeliveryTimes < ActiveRecord::Migration
  def self.up
    create_table :delivery_times do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :delivery_times
  end
end
