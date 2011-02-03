class AddNewContent1AndNewContent2ToUrls < ActiveRecord::Migration
  def self.up
    add_column :urls, :new_content1, :text
    add_column :urls, :new_content2, :text
  end

  def self.down
    remove_column :urls, :new_content2
    remove_column :urls, :new_content1
  end
end
