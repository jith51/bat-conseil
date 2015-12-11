class AddTvaIdToPrestation < ActiveRecord::Migration
  def change
  	remove_column :prestations, :tva
  	add_column :prestations, :tva_id, :integer
  end
end
