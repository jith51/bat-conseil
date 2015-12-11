class AddLibelleToEstiimation < ActiveRecord::Migration
  def change
  	add_column :estimations, :libelle, :string
  end
end
