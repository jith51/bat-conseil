class AddCustomerToEstimation < ActiveRecord::Migration
  def change
  	add_column :estimations, :customer_id, :integer
  end
end
