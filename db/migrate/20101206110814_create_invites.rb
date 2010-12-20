class CreateInvites < ActiveRecord::Migration
  def self.up
    create_table :invites do |t|
      t.boolean :tuangou,:default=>false
      t.integer :user_id
      t.integer :invited_user_id
      t.string :ip
      t.string :from

      t.timestamps
    end
  end

  def self.down
    drop_table :invites
  end
end
