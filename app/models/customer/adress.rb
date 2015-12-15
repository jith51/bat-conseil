class Customer::Adress < ActiveRecord::Base
	validates :name, :rue, :code_postal, :ville, presence: true, uniqueness: true
	validates :rue, :code_postal, :ville, presence: true
end
