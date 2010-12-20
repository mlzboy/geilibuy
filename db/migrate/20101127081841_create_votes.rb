class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.string :name
      t.integer :position,:default=>0
      t.integer :parent_id

      t.timestamps
    end
  end

  def self.down
    drop_table :votes
  end
end
