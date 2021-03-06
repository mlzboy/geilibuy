class CreateMaterials < ActiveRecord::Migration
  def self.up
    create_table :materials do |t|
      t.string :name
      t.string :type
      t.string :hyperlink
      t.string :title
      t.string :alt
      t.string :text
      t.text :memo

      t.timestamps
    end
  end

  def self.down
    drop_table :materials
  end
end
