class Category < ApplicationRecord
  has_many :productxcategories
  has_many :products, through: :productxcategories
end
