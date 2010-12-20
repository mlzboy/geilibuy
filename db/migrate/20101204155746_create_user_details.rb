class CreateUserDetails < ActiveRecord::Migration
  def self.up
    create_table :user_details do |t|
      t.integer :user_id
      t.boolean :gender,:default=>0
      t.integer :job_id
      t.integer :education_id
      t.datetime :birthday
      t.text :introduce

      t.timestamps
    end
  end

  def self.down
    drop_table :user_details
  end
end
