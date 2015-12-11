class AddEstimationIdToEstimationVolet < ActiveRecord::Migration
  def change
  	add_column :estimation_volets, :estimation_id, :integer
  end
end
