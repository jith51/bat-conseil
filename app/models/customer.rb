class Customer < ActiveRecord::Base
	
	has_many :adresses, dependent: :destroy
	accepts_nested_attributes_for :adresses, allow_destroy: true

	def name
		return self.first_name + ' ' + self.last_name
	end

end
