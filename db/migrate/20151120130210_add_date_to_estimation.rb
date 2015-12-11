class AddDateToEstimation < ActiveRecord::Migration
  def change
  	add_column :estimations, :validity_date, :date
  	add_column :estimations, :intervention_dates, :text
  end
end
