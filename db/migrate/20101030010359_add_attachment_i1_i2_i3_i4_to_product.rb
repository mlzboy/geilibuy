class AddAttachmentI1I2I3I4ToProduct < ActiveRecord::Migration
  def self.up
    add_column :products, :i1_file_name, :string
    add_column :products, :i1_content_type, :string
    add_column :products, :i1_file_size, :integer
    add_column :products, :i1_updated_at, :datetime
    add_column :products, :i2_file_name, :string
    add_column :products, :i2_content_type, :string
    add_column :products, :i2_file_size, :integer
    add_column :products, :i2_updated_at, :datetime
    add_column :products, :i3_file_name, :string
    add_column :products, :i3_content_type, :string
    add_column :products, :i3_file_size, :integer
    add_column :products, :i3_updated_at, :datetime
    add_column :products, :i4_file_name, :string
    add_column :products, :i4_content_type, :string
    add_column :products, :i4_file_size, :integer
    add_column :products, :i4_updated_at, :datetime
  end

  def self.down
    remove_column :products, :i1_file_name
    remove_column :products, :i1_content_type
    remove_column :products, :i1_file_size
    remove_column :products, :i1_updated_at
    remove_column :products, :i2_file_name
    remove_column :products, :i2_content_type
    remove_column :products, :i2_file_size
    remove_column :products, :i2_updated_at
    remove_column :products, :i3_file_name
    remove_column :products, :i3_content_type
    remove_column :products, :i3_file_size
    remove_column :products, :i3_updated_at
    remove_column :products, :i4_file_name
    remove_column :products, :i4_content_type
    remove_column :products, :i4_file_size
    remove_column :products, :i4_updated_at
  end
end
