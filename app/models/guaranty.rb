class Guaranty < ActiveRecord::Base
	alias_attribute :name, :libelle
	validates :libelle, presence: true, uniqueness: true
end