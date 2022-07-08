# frozen_string_literal: true

class Ingredient < ApplicationRecord
  belongs_to :recipe

  validates :name, :quantity, presence: true

  enum unit_type: { ml: 0, g: 1 }
end
