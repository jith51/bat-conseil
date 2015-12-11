class AddCustomerIdToAddress < ActiveRecord::Migration
  def change
  	add_column :customer_adresses, :customer_id, :integer
  end
end
