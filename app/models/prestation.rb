class Prestation < ActiveRecord::Base
	 alias_attribute :name, :libelle
	 belongs_to :tva
end
