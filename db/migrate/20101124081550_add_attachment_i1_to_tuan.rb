class AddAttachmentI1ToTuan < ActiveRecord::Migration
  def self.up
    add_column :tuans, :i1_file_name, :string
    add_column :tuans, :i1_content_type, :string
    add_column :tuans, :i1_file_size, :integer
    add_column :tuans, :i1_updated_at, :datetime
  end

  def self.down
    remove_column :tuans, :i1_file_name
    remove_column :tuans, :i1_content_type
    remove_column :tuans, :i1_file_size
    remove_column :tuans, :i1_updated_at
  end
end
