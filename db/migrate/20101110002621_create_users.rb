class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :email
      t.string :password
      t.boolean :active
      t.string :active_code

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
