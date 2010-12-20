class AddPresaleConsultingValueColumn < ActiveRecord::Migration
  def self.up
    add_column :presale_consultings,:value,:boolean,:default=>0
    add_column :presale_consultings,:reply,:text
  end

  def self.down
    remove_column :presale_consultings,:value
    remove_column :presale_consultings,:reply
  end
end
