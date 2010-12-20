class AddIpToQas < ActiveRecord::Migration
  def self.up
    add_column :qas, :ip, :string
  end

  def self.down
    remove_column :qas, :ip
  end
end
