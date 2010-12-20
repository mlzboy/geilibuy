class AddUserIdToPresaleConsultingsAddProductIdToPresaleConsultings < ActiveRecord::Migration
  def self.up
    add_column :presale_consultings, :user_id, :integer
    add_column :presale_consultings, :product_id, :integer
  end

  def self.down
    remove_column :presale_consultings, :product_id
    remove_column :presale_consultings, :user_id
  end
end
