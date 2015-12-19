class AddGuarantyIdToEstimation < ActiveRecord::Migration
  def change
  	add_column :estimations, :guaranty_id, :integer
  end
end
