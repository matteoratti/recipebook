# frozen_string_literal: true

class Ingredient < ApplicationRecord
  has_many :steps_ingredients, dependent: :destroy
  has_many :steps, through: :steps_ingredients

  has_many :tags, as: :taggable, dependent: :destroy

  include HasLikes

  validates :name, :unit_type, presence: true

  enum unit_type: { ml: 0, g: 1, unit: 2 }
end
