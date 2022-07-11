# frozen_string_literal: true

class Recipe < ApplicationRecord
  has_many :recipes_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipes_ingredients

  has_many :steps, dependent: :destroy

  validates :name, :body, presence: true

  accepts_nested_attributes_for :recipes_ingredients, :steps
end
