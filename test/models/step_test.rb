# frozen_string_literal: true

require 'test_helper'

class StepTest < ActiveSupport::TestCase
  def setup
    recipe = recipes(:carbonara)
    @step = Step.new(recipe:, description: 'sbattere le uova', order: 1, body: 'this is a body', duration: 1200)
  end

  test 'valid step' do
    assert @step.valid?
  end

  test 'invalid without description' do
    @step.description = nil
    assert_not @step.valid?, 'saved step without a description'
    assert_not_nil @step.errors[:name], 'no validation error for step present'
  end

  test 'valid without duration' do
    @step.duration = nil
    assert @step.valid?, 'saved step without a step'
  end

  test 'invalid without order' do
    @step.order = nil
    assert_not @step.valid?, 'saved step without a order'
    assert_equal "Order can't be blank", @step.errors.full_messages.first
  end

  test 'save a valid step' do
    assert @step.save
  end

  test 'not save an invalid step' do
    %i[description order body].each do |field|
      @step[field] = nil
      assert_not @step.save
    end
  end

  test 'invalid step without recipe' do
    @step.recipe = nil
    assert_not @step.valid?
  end

  test 'if step associated ingredient does not exists, create it' do
    ingredient = Ingredient.new(name: 'a new ingredient', unit_type: 'ml')

    assert_not Ingredient.find_by_name(ingredient.name)

    @step.step_ingredients.build({ step: @step, ingredient:, quantity: 10 })
    @step.save

    assert Ingredient.find_by_name(ingredient.name)
  end

  test 'if step associated ingredient does exists, find it' do
    ingredient = ingredients(:uova)

    assert Ingredient.find(ingredient.id)

    @step.step_ingredients.build({ step: @step, ingredient:, quantity: 10 })
    @step.save

    assert @step.step_ingredients.first.ingredient.id == ingredient.id
  end
end
