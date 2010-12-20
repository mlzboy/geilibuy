class CreateVoteDetails < ActiveRecord::Migration
  def self.up
    create_table :vote_details do |t|
      t.string :ip
      t.integer :vote_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :vote_details
  end
end
