class CreateCustomerAdresses < ActiveRecord::Migration
  def change
    create_table :customer_adresses do |t|
    	t.string :rue
    	t.string :complement
    	t.string :code_postal
    	t.string :ville
      t.timestamps null: false
    end
  end
end
