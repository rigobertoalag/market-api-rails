class Category < ApplicationRecord
  has_many :items

  validates :name, presence: true, length: { minimum: 3 }
  validates :description, presence: true, length: { minimum: 10, maximum: 100 }
end
