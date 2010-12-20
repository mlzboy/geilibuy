class AddTotalLuckyToLotteryDetails < ActiveRecord::Migration
  def self.up
    add_column :lottery_details, :total_lucky, :integer
    add_column :lottery_details, :winning, :boolean,:default=>false
  end

  def self.down
    remove_column :lottery_details, :total_lucky
    remove_column :lottery_details, :winning
  end
end
