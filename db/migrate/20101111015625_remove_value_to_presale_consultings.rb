class RemoveValueToPresaleConsultings < ActiveRecord::Migration
  def self.up
    remove_column :presale_consultings, :value
    remove_column :presale_consultings, :hide
    remove_column :presale_consultings, :user_id
    add_column :presale_consultings, :value,  :boolean,:default=>0
    add_column :presale_consultings, :hide,   :boolean,:default=>0
    add_column :presale_consultings, :user_id,:integer,:default=>-1
  end

  def self.down
  end
end
