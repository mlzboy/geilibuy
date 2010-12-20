class ModifyMaterialSoltAssocationTable < ActiveRecord::Migration
  def self.up
    drop_table :materials_slots
    create_table :materials_slots,:id=>false do |t|
      t.integer :material_id
      t.integer :slot_id
      t.integer :position
    end
  end

  def self.down
    create_table :materials_slots do |t|
      t.integer :material_id
      t.integer :slot_id
      t.integer :position

      t.timestamps
    end
  end
end
