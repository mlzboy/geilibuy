class AddSnToCashDetails < ActiveRecord::Migration
  def self.up
    add_column :cash_details, :sn, :string
  end

  def self.down
    remove_column :cash_details, :sn
  end
end
