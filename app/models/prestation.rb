class Prestation < ActiveRecord::Base
	 alias_attribute :name, :libelle
	 validates :unite, :price, presence: true
	 validates :libelle, presence: true, uniqueness: true
	 belongs_to :tva, required: true
	 has_many :prestation_lines, class_name: 'Estimation::PrestationLine', dependent: :restrict_with_exception
end
