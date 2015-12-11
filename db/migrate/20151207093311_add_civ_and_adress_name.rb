class AddCivAndAdressName < ActiveRecord::Migration
  def change
  	add_column :customers, :civilite, :string
  	add_column :customer_adresses, :name, :string
  end
end