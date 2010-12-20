class AddHideToPresaleConsulting < ActiveRecord::Migration
  def self.up
    add_column :presale_consultings, :hide, :boolean,:default=>0
  end

  def self.down
    remove_column :presale_consultings, :hide
  end
end
