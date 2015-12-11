class CreateEstimations < ActiveRecord::Migration
  def change
    create_table :estimations do |t|
    	t.string :reference
    	t.text :objet
      t.timestamps null: false
    end
    create_table :estimation_volets do |t|
    	t.string :libelle
      t.timestamps null: false
    end
  end
end
