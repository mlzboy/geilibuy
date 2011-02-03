class AddContent2ToUrls < ActiveRecord::Migration
  def self.up
    #add_column :urls, :content2, :text,:limit=>128.kilobytes
     change_column :urls,:content,:text,:limit=>128.kilobytes
  end

  def self.down
    #remove_column :urls, :content2
  end
end
