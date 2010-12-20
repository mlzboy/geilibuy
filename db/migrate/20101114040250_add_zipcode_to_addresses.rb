class AddZipcodeToAddresses < ActiveRecord::Migration
  def self.up
    add_column :addresses, :zipcode, :string
  end

  def self.down
    remove_column :addresses, :zipcode
  end
end
