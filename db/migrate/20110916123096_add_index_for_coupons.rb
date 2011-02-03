class AddIndexForCoupons < ActiveRecord::Migration
  def self.up
	add_index :coupons,[:user_id,:start_time,:end_time,:status,:min_money,:hide],:name=>"coupons_union_index"
  end

  def self.down
	remove_index :coupons,:name=>"coupons_union_index"
  end
end
