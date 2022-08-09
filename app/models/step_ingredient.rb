# frozen_string_literal: true

class StepIngredient < ApplicationRecord
  belongs_to :step
  belongs_to :ingredient

  before_validation :set_step_description, :set_ingredient_name

  validates :step_description, :ingredient_name, presence: true

  accepts_nested_attributes_for :ingredient

  private

  def set_step_description
    self.step_description = step.description
  end

  def set_ingredient_name
    self.ingredient_name = ingredient.name
  end
end
