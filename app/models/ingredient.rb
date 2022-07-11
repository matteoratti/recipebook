# frozen_string_literal: true

class Ingredient < ApplicationRecord
  has_many :recipes_ingredients, dependent: :destroy
  has_many :recipes, through: :recipes_ingredients

  validates :name, :unit_type, presence: true

  enum unit_type: { ml: 0, g: 1, unit: 2 }
end
