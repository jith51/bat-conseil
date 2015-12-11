class AddTvaToPrestations < ActiveRecord::Migration
  def change
  	add_column :prestations, :tva, :decimal
  end
end
