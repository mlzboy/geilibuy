class AddScoreToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :score, :boolean,:default=>0
    add_column :orders, :s1,    :integer,:default=>0
  end

  def self.down
    remove_column :orders, :score
    remove_column :orders, :s1
  end
end
