class Estimation::Volet < ActiveRecord::Base
	has_many :prestation_lines, dependent: :destroy
	accepts_nested_attributes_for :prestation_lines, allow_destroy: true
	validates :libelle, presence: true
end
