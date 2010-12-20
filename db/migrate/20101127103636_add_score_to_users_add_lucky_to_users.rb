class AddScoreToUsersAddLuckyToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :score, :integer,:default=>0
    add_column :users, :lucky, :integer,:default=>0
  end

  def self.down
    remove_column :users, :lucky
    remove_column :users, :score
  end
end
