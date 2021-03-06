class CreateQas < ActiveRecord::Migration
  def self.up
    create_table :qas do |t|
      t.integer :user_id
      t.text :question
      t.text :answer

      t.timestamps
    end
  end

  def self.down
    drop_table :qas
  end
end
