class CreateUrls < ActiveRecord::Migration
  def self.up
    create_table :urls do |t|
      t.string :site
      t.string :kind
      t.string :url
      t.boolean :success,:default=>false
      t.text :content
      t.timestamps
    end
  end

  def self.down
    drop_table :urls
  end
end
