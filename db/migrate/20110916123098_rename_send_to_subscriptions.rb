class RenameSendToSubscriptions < ActiveRecord::Migration
  def self.up
	rename_column :subscriptions,:send,:sended
  end

  def self.down
  end
end
