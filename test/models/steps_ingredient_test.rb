# frozen_string_literal: true

require 'test_helper'

class StepsIngredientTest < ActiveSupport::TestCase
  def setup
    @step_ingredients = StepIngredient.new(step: steps(:one), ingredient: ingredients(:uova), quantity: 5)
  end

  test 'a valid steps ingredient' do
    assert @step_ingredients.valid?
  end

  test 'save a valid steps ingredient' do
    assert @step_ingredients.save
  end

  test 'step_description should exist before validation' do
    assert @step_ingredients.valid?

    assert @step_ingredients.step_description
  end

  test 'ingredient_name should exist before validation' do
    assert @step_ingredients.valid?

    assert @step_ingredients.ingredient_name
  end

  test 'step_description should exist after save' do
    @step_ingredients.save

    assert_equal @step_ingredients.step.description, @step_ingredients.step_description
  end

  test 'ingredient_name should exist after save' do
    @step_ingredients.save

    assert_equal @step_ingredients.ingredient.name, @step_ingredients.ingredient_name
  end
end
