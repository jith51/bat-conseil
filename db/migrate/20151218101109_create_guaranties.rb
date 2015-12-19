class CreateGuaranties < ActiveRecord::Migration
  def change
    create_table :guaranties do |t|
			t.string :libelle
    	t.string :description
      t.timestamps null: false
    end
  end
end
