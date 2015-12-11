class CreatePrestationModels < ActiveRecord::Migration
  def change
    create_table :prestation_models do |t|
    	t.string :libelle
    	t.string :description
    	t.decimal :price
    	t.string :unite
      t.timestamps null: false
    end
  end
end
