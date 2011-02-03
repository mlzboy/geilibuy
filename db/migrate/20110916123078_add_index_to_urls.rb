class AddIndexToUrls < ActiveRecord::Migration
  def self.up
	add_index :urls,:success,:name=>"urls_success_index"
	add_index :urls,:site,:name=>"urls_site_index"
  end

  def self.down
	remove_index :urls,:success,:name=>"urls_success_index"
	remove_index :urls,:site,:name=>"urls_site_index"
  end
end
