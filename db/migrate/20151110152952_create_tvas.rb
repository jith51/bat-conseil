class CreateTvas < ActiveRecord::Migration
  def change
    create_table :tvas do |t|
    	t.decimal :value
      t.timestamps null: false
    end
  end
end
