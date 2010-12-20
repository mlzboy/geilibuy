class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.string :name
      t.decimal :p1
      t.decimal :p2
      t.decimal :p3
      t.decimal :p4
      t.decimal :p5
      t.boolean :promotion,:default=>0
      t.boolean :new,:default=>1
      t.boolean :score,:default=>0
      t.integer :s1
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :products
  end
end
