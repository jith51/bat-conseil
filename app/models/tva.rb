class Tva < ActiveRecord::Base
	has_many :prestations, dependent: :restrict_with_exception
	validates :value, presence: true, uniqueness: true
	def name
		self.value.to_s
	end
end
