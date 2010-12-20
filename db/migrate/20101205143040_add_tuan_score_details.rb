class AddTuanScoreDetails < ActiveRecord::Migration
  def self.up
	add_column :score_details,:tuangou,:boolean,:default=>false
  end

  def self.down
	remove_column :score_details,:tuangou
  end
end
