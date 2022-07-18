# frozen_string_literal: true

require 'test_helper'

class RecipesIngredientTest < ActiveSupport::TestCase
  def setup
    @recipes_ingredient = RecipesIngredient.new(recipe: recipes(:carbonara), ingredient: ingredients(:uova), quantity: 5 )
  end

  test 'a valid recipes ingredient' do
    assert @recipes_ingredient.valid?
  end

  test 'save a valid recipes ingredient' do
    assert @recipes_ingredient.save
  end

  test 'recipe_name should exist before validation' do
    assert @recipes_ingredient.valid?

    assert @recipes_ingredient.recipe_name
  end

  test 'ingredient_name should exist before validation' do
    assert @recipes_ingredient.valid?

    assert @recipes_ingredient.ingredient_name
  end

  test 'recipe_name should exist after save' do
    @recipes_ingredient.save

    assert_equal @recipes_ingredient.recipe.name, @recipes_ingredient.recipe_name
  end

  test 'ingredient_name should exist after save' do
    @recipes_ingredient.save

    assert_equal @recipes_ingredient.ingredient.name, @recipes_ingredient.ingredient_name
  end
end
