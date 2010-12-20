class CreateInviteDetails < ActiveRecord::Migration
  def self.up
    create_table :invite_details do |t|
      t.integer :invite_id
      t.string :name
      t.integer :value,:default=>1

      t.timestamps
    end
  end

  def self.down
    drop_table :invite_details
  end
end
