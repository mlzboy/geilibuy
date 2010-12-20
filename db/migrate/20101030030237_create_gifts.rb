class CreateGifts < ActiveRecord::Migration
  def self.up
    create_table :gifts do |t|
      t.string :name
      t.boolean :leaf
      t.text :memo
      t.string :uuid

      t.timestamps
    end
  end

  def self.down
    drop_table :gifts
  end
end
