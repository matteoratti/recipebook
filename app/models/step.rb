# frozen_string_literal: true

class Step < ApplicationRecord
  belongs_to :recipe

  has_many :step_ingredients, -> { includes :ingredient }, dependent: :destroy
  has_many :ingredients, through: :step_ingredients

  include HasLikes

  validates :description, :body, :order, presence: true

  accepts_nested_attributes_for :step_ingredients, allow_destroy: true

  scope :with_step_ingredients, -> { includes(:step_ingredients) }

  before_save :find_or_create_ingredients

  def find_or_create_ingredients
    step_ingredients.each do |step_ingredient|
      step_ingredient.ingredient = Ingredient.find_or_create_by(name: step_ingredient.ingredient.name) do |ingredient|
        ingredient.unit_type = step_ingredient.ingredient.unit_type
      end
    end
  end
end
