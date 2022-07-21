# frozen_string_literal: true

class RecipesIngredient < ApplicationRecord
  belongs_to :recipe
  belongs_to :ingredient

  before_validation :set_recipe_name, :set_ingredient_name

  validates :recipe_name, :ingredient_name, presence: true

  private

  def set_recipe_name
    self.recipe_name = recipe.name
  end

  def set_ingredient_name
    self.ingredient_name = ingredient.name
  end
end
