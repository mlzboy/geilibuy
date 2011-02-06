class AddSendToSubscriptions < ActiveRecord::Migration
  def self.up
    add_column :subscriptions, :send, :boolean,:default=>false
    add_index  :subscriptions, :subscribe
  end

  def self.down
    remove_column :subscriptions, :send
    remove_index :subscriptions, :subscribe
  end
end
