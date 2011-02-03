class AddIndexToUrlsForMyurlColumn < ActiveRecord::Migration
  def self.up
	add_index :urls,:myurl,:name=>"urls_myurl_index",:unique=>true
  end

  def self.down
	remove_index :urls,:myurl
  end
end
