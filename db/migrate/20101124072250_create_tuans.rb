#coding:utf-8
class CreateTuans < ActiveRecord::Migration
  def self.up
    create_table :tuans do |t|
      t.integer :product_id
      t.string :status,:default=>"抢购"
      t.decimal :pp1,:precision => 15, :scale => 3, :default => 0.0
      t.decimal :dp1,:precision => 15, :scale => 3, :default => 0.0
      t.integer :dp1_num,:integer,:default=>1
      t.decimal :dp2,:precision => 15, :scale => 3, :default => 0.0
      t.integer :dp2_num,:integer,:default=>2
      t.string :title
      t.datetime :start_time
      t.datetime :end_time
      t.datetime :min_time
      t.integer :min_num,:default=>10
      t.datetime :max_time
      t.integer :max_num,:default=>0
      t.boolean :on,:default=>1
      t.text:ts1
      t.string:ts1_name
      t.text:ts2
      t.string:ts2_name
      t.text:ts3
      t.string:ts3_name
      t.text:ws1

      t.timestamps
    end
  end

  def self.down
    drop_table :tuans
  end
end
