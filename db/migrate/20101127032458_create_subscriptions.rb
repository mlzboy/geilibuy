class CreateSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :subscriptions do |t|
      t.string :email
      t.boolean :subscribe,:default=>1
      t.boolean :tuan,:default=>1

      t.timestamps
    end
  end

  def self.down
    drop_table :subscriptions
  end
end
