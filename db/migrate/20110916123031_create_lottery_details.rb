class CreateLotteryDetails < ActiveRecord::Migration
  def self.up
    create_table :lottery_details do |t|
      t.integer :user_id
      t.text :say
      t.boolean :big
      t.string :ip
      t.timestamps
    end
  end

  def self.down
    drop_table :lottery_details
  end
end
