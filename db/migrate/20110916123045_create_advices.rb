class CreateAdvices < ActiveRecord::Migration
  def self.up
    create_table :advices do |t|
      t.text :content
      t.string :ip

      t.timestamps
    end
  end

  def self.down
    drop_table :advices
  end
end
