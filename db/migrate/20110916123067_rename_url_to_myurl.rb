class RenameUrlToMyurl < ActiveRecord::Migration
  def self.up
	rename_column :urls,:url,:myurl
  end

  def self.down
	rename_column :urls,:myurl,:url
  end
end
