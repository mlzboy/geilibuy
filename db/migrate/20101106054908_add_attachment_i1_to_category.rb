class AddAttachmentI1ToCategory < ActiveRecord::Migration
  def self.up
    add_column :categories, :i1_file_name, :string
    add_column :categories, :i1_content_type, :string
    add_column :categories, :i1_file_size, :integer
    add_column :categories, :i1_updated_at, :datetime
  end

  def self.down
    remove_column :categories, :i1_file_name
    remove_column :categories, :i1_content_type
    remove_column :categories, :i1_file_size
    remove_column :categories, :i1_updated_at
  end
end
