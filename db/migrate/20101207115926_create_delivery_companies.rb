class CreateDeliveryCompanies < ActiveRecord::Migration
  def self.up
    create_table :delivery_companies do |t|
      t.string :name
      t.string :url
      t.text :memo

      t.timestamps
    end
  end

  def self.down
    drop_table :delivery_companies
  end
end
