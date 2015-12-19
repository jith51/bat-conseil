class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

	validates :email, presence: true, uniqueness: true,  format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i}
  validates :password, presence: true, confirmation: true
  validates :password_confirmation, presence: true

end