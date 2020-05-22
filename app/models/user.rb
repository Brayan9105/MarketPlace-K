class User < ApplicationRecord
  has_many :products
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
