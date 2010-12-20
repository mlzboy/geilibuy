class CreateMaterialsSlots < ActiveRecord::Migration
  def self.up
    create_table :materials_slots do |t|
      t.integer :material_id
      t.integer :slot_id
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :materials_slots
  end
end
