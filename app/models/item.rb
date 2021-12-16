class Item < ApplicationRecord
  belongs_to :user

  validates :name, presence: true, length: { minimum: 3 }
  validates :description, presence: true, length: { minimum: 10, maximum: 100 }
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :category_id, presence: true
end
