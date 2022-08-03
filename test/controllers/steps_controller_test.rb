# frozen_string_literal: true

require 'test_helper'

class StepsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @step = steps(:one)
    @recipe = @step.recipe
  end

  test 'should get new' do
    get new_recipe_step_url(@recipe)
    assert_response :success
  end

  test 'should create a step' do
    params = { step: {
      description: 'step description',
      order:       1,
      body:        'step body',
      duration:    120
    } }

    assert_difference('Step.count') do
      post recipe_steps_url(@recipe), params: params
    end

    assert_response :success
  end

  test 'should not create a step with invalid params' do
    params = { step: {
      description: nil,
      order:       nil,
      body:        nil,
      duration:    nil
    } }

    assert_no_difference('Step.count') do
      post recipe_steps_url(@recipe), params: params
    end

    assert_response :unprocessable_entity
  end

  test 'should update recipe' do
    new_params = { step: {
      description: 'new step description',
      order:       2,
      body:        'new step body',
      duration:    240
    } }

    patch recipe_step_url(@recipe, @step), params: new_params

    @step.reload

    assert_equal new_params[:step],
                 @step.attributes.symbolize_keys.except(:id, :created_at, :updated_at, :recipe_id)

    assert_response :success
  end

  test 'should not update a step with invalid params' do
    new_params = { step: {
      description: nil,
      order:       nil,
      body:        nil,
      duration:    nil
    } }

    patch recipe_step_url(@recipe, @step), params: new_params

    assert_response :unprocessable_entity
  end

  test 'should destroy a step' do
    assert_difference('Step.count', -1) do
      delete recipe_step_url(@recipe, @step)
    end

    assert_response :success
  end

  test 'should destroy step ingredients when destroy step' do
    assert_difference('StepsIngredient.count', -1) do
      delete recipe_step_url(@recipe, @step)
    end

    assert_response :success
  end

  test 'create a step with step ingredients' do
    ingredient1 = ingredients(:uova)
    ingredient2 = ingredients(:parmiggiano)
    step_ingredients = [
      { ingredient_id: ingredient1.id, quantity: 1 },
      { ingredient_id: ingredient2.id, quantity: 4 }
    ]

    params = { step: {
      description:                  'step description',
      order:                        1,
      body:                         'step body',
      duration:                     120,
      steps_ingredients_attributes: step_ingredients
    } }

    assert_difference('Step.count') do
      post recipe_steps_url(@recipe), params: params
    end

    assert_equal step_ingredients[0],
                 Step.last.steps_ingredients.first.attributes.symbolize_keys
                     .except(:id, :created_at, :updated_at, :recipe_id, :step_id, :ingredient_name, :step_description)

    assert_response 200
  end
end
