class Tva < ActiveRecord::Base
	def name
		self.value.to_s
	end
end
