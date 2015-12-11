class Estimation::PrestationLine < ActiveRecord::Base
	belongs_to :prestation,  required: true
	delegate :price, :description, :unite, :tva, to: :prestation, allow_nil: true 
end