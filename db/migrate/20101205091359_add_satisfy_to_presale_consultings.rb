class AddSatisfyToPresaleConsultings < ActiveRecord::Migration
  def self.up
    add_column :presale_consultings,  :satisfy,:boolean
  end

  def self.down
    remove_column :presale_consultings, :satisfy
  end
end
