class AddDeliveryCompanyIdToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :delivery_company_id, :integer
    add_column :orders, :delivery_company_name, :string
    add_column :orders, :delivery_no, :string
  end

  def self.down
    remove_column :orders, :delivery_company_id
    remove_column :orders, :delivery_company_name
    remove_column :orders, :delivery_no
  end
end
