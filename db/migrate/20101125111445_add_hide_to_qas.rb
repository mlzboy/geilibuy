class AddHideToQas < ActiveRecord::Migration
  def self.up
    add_column :qas, :hide, :boolean,:default=>0
		
  end

  def self.down
    remove_column :qas, :hide
  end
end
