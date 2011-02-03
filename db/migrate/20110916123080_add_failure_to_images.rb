class AddFailureToImages < ActiveRecord::Migration
  def self.up
    add_column :images, :failure, :boolean,:default=>false
  end

  def self.down
    remove_column :images, :failure
  end
end
