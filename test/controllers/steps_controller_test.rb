# frozen_string_literal: true

require 'test_helper'

class StepsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @step = steps(:one)
    @recipe = @step.recipe
    @step_ingredients = StepIngredient.create(step: @step, ingredient: ingredients(:uova), quantity: 5)
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

  test 'should update a step' do
    new_params = { step: {
      description: 'new step description',
      order:       2,
      body:        'new step body',
      duration:    240
    } }

    patch step_url(@step), params: new_params

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

    patch step_url(@step), params: new_params

    assert_response :unprocessable_entity
  end

  test 'should destroy a step' do
    assert_difference('Step.count', -1) do
      delete step_url(@step)
    end

    assert_response :success
  end

  test 'should destroy step ingredients when destroy step' do
    assert_difference('StepIngredient.count', -1) do
      delete step_url(@step)
    end

    assert_response :success
  end

  test 'create a step with step ingredients' do
    ingredient1 = ingredients(:uova)

    params = { step: {
      description:                 'step description',
      order:                       1,
      duration:                    120,
      body:                        'step body',
      step_ingredients_attributes: { '0' => { quantity: 10, ingredient_attributes: { name: ingredient1.name, unit_type: ingredient1.unit_type } } }
    } }

    assert_difference('Step.count') do
      post recipe_steps_url(@recipe), params: params
    end

    assert_equal params[:step][:step_ingredients_attributes]['0'][:ingredient_attributes][:name],
                 Step.last.step_ingredients.first.attributes.symbolize_keys
                     .except(:id, :created_at, :updated_at, :recipe_id, :step_id, :ingredient_id, :quantity, :step_description)[:ingredient_name]

    assert_equal params[:step][:step_ingredients_attributes]['0'][:quantity],
                 Step.last.step_ingredients.first.attributes.symbolize_keys
                     .except(:id, :created_at, :updated_at, :recipe_id, :step_id, :ingredient_id, :ingredient_name, :step_description)[:quantity]

    assert_response 200
  end

  test 'update a step with step ingredients' do
    new_params = { step: {
      description:                 'new step description',
      order:                       3,
      duration:                    10,
      body:                        'new step body',
      step_ingredients_attributes: { '0' => { quantity: 10, ingredient_attributes: { name: 'new ingredient name', unit_type: 'ml' } } }
    } }

    patch step_url(@step), params: new_params

    @step.reload

    assert_equal new_params[:step][:step_ingredients_attributes]['0'][:ingredient_attributes][:name],
                 @step.step_ingredients.last.attributes.symbolize_keys.except(:id, :created_at, :updated_at, :recipe_id, :step_id, :ingredient_id, :quantity, :step_description)[:ingredient_name]

    assert_equal new_params[:step][:step_ingredients_attributes]['0'][:quantity],
                 @step.step_ingredients.last.attributes.symbolize_keys
                      .except(:id, :created_at, :updated_at, :recipe_id, :step_id, :ingredient_id, :ingredient_name, :step_description)[:quantity]

    assert_response :success
  end
end
