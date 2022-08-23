# frozen_string_literal: true

class StepIngredientsController < ApplicationController
  before_action :set_step

  # include Logify
  # after_action :logify_action

  private

  def set_step
    @step = Step.new(step_ingredients: [StepIngredient.new(ingredient: Ingredient.new)])
  end
end
