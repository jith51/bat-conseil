class Prestation < ActiveRecord::Base
	 alias_attribute :name, :libelle
	 validates :libelle, :unite, :price, presence: true
	 belongs_to :tva, required: true
end
