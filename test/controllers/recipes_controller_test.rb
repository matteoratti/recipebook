# frozen_string_literal: true

require 'test_helper'

class RecipesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @recipe = recipes(:carbonara)
  end

  test 'should get index' do
    get recipes_url
    assert_response :success
  end

  test 'should get new' do
    get new_recipe_url
    assert_response :success
  end

  test 'should create recipe' do
    assert_difference('Recipe.count') do
      post recipes_url, params: { recipe: { body: @recipe.body, name: @recipe.name } }
    end

    assert_redirected_to recipe_url(Recipe.last)
  end

  test 'should show recipe' do
    get recipe_url(@recipe)
    assert_response :success
  end

  test 'should get edit' do
    get edit_recipe_url(@recipe)
    assert_response :success
  end

  test 'should update recipe' do
    patch recipe_url(@recipe), params: { recipe: { body: @recipe.body, name: @recipe.name } }
    assert_redirected_to recipe_url(@recipe)
  end

  test 'should destroy recipe' do
    assert_difference('Recipe.count', -1) do
      delete recipe_url(@recipe)
    end

    assert_redirected_to recipes_url
  end

  test 'invalid recipe creation' do
    assert_no_difference('Recipe.count') do
      post recipes_url, params: { recipe: { body: @recipe.body, name: nil } }
    end

    assert_response 422
  end

  test 'invalid recipe update' do
    patch recipe_url(@recipe), params: { recipe: { body: @recipe.body, name: nil } }
    assert_response 422
  end

  test 'create a recipe with ingredients' do
    ingredients = [
      { name: 'uova', unit_type: 'ml', quantity: 1 },
      { name: 'pancetta', unit_type: 'g', quantity: 5 }
    ]

    assert_difference('Recipe.count') do
      post recipes_url,
           params: { recipe: { body: @recipe.body, name: @recipe.name, ingredients_attributes: ingredients } }
    end

    assert_equal ingredients[0],
                 Recipe.last.ingredients.first.attributes.symbolize_keys.except(:id, :created_at, :updated_at,
                                                                                :recipe_id)
    assert_redirected_to recipe_url(Recipe.last)
  end

  test 'create a recipe with steps' do
    steps = [
      { description: 'bollire uova', order: 1, body: 'this is a body', duration: 1200 },
      { description: 'pelare patate', order: 2, body: 'this is a body for potatoes', duration: 600 }
    ]

    assert_difference('Recipe.count') do
      post recipes_url, params: { recipe: { body: @recipe.body, name: @recipe.name, steps_attributes: steps } }
    end

    assert_equal steps[0],
                 Recipe.last.steps.first.attributes.symbolize_keys.except(:id, :created_at, :updated_at, :recipe_id)
    assert_redirected_to recipe_url(Recipe.last)
  end
end
