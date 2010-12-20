class CreateLotteries < ActiveRecord::Migration
  def self.up
    create_table :lotteries do |t|
      t.integer :first_num,:default=>0
      t.integer :second_num,:default=>0
      t.integer :third_num,:default=>0
      t.integer :first_rate,:default=>300
      t.integer :second_rate,:default=>200
      t.integer :third_rate,:default=>100

      t.timestamps
    end
  end

  def self.down
    drop_table :lotteries
  end
end
