class AddLinePrestation < ActiveRecord::Migration
  def change
  	create_table :estimation_prestation_lines do |t|
    	t.references :volet
    	t.references :prestation
    	t.integer :quantite
      t.timestamps null: false
    end
  end
end
