# frozen_string_literal: true

require 'test_helper'

class StepTest < ActiveSupport::TestCase
  def setup
    recipe = recipes(:carbonara)
    @step = Step.new(recipe: recipe, description: 'sbattere le uova', order: 1, body: 'this is a body', duration: 1200)
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
end
