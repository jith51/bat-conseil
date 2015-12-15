class Customer < ActiveRecord::Base
	
	has_many :adresses, dependent: :destroy
	accepts_nested_attributes_for :adresses, allow_destroy: true

	# Validation
	validates :customer_id, :civilite, :first_name, presence: true
	validates :customer_id, uniqueness: true

	validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }

	def name
		return self.first_name + ' ' + self.last_name
	end

end
