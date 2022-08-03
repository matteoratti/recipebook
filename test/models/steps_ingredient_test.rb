# frozen_string_literal: true

require 'test_helper'

class StepsIngredientTest < ActiveSupport::TestCase
  def setup
    @steps_ingredient = StepsIngredient.new(step: steps(:one), ingredient: ingredients(:uova), quantity: 5)
  end

  test 'a valid steps ingredient' do
    assert @steps_ingredient.valid?
  end

  test 'save a valid steps ingredient' do
    assert @steps_ingredient.save
  end

  test 'step_description should exist before validation' do
    assert @steps_ingredient.valid?

    assert @steps_ingredient.step_description
  end

  test 'ingredient_name should exist before validation' do
    assert @steps_ingredient.valid?

    assert @steps_ingredient.ingredient_name
  end

  test 'step_description should exist after save' do
    @steps_ingredient.save

    assert_equal @steps_ingredient.step.description, @steps_ingredient.step_description
  end

  test 'ingredient_name should exist after save' do
    @steps_ingredient.save

    assert_equal @steps_ingredient.ingredient.name, @steps_ingredient.ingredient_name
  end
end
