class CreateScoreDetails < ActiveRecord::Migration
  def self.up
    create_table :score_details do |t|
      t.integer :user_id
      t.integer :score
      t.text :memo
      t.boolean :cost

      t.timestamps
    end
  end

  def self.down
    drop_table :score_details
  end
end
