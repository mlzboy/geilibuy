class CreatePresaleConsultings < ActiveRecord::Migration
  def self.up
    create_table :presale_consultings do |t|
      #t.integer :user_id
      t.text :content
      t.string :ip

      t.timestamps
    end
  end

  def self.down
    drop_table :presale_consultings
  end
end
