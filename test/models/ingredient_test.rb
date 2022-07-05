# frozen_string_literal: true

require 'test_helper'

class IngredientTest < ActiveSupport::TestCase
  def setup
    # take recipe from recipes fixture
    recipe = recipes(:carbonara)
    @ingredient = Ingredient.new(recipe: recipe, name: 'uova', quantity: 10)
  end

  test 'valid ingredient' do
    assert @ingredient.valid?
  end

  test 'invalid without name' do
    @ingredient.name = nil
    assert_not @ingredient.valid?, 'saved ingredient without a name'
    assert_not_nil @ingredient.errors[:name], 'no validation error for ingredient present'
  end

  test 'invalid without quantity' do
    @ingredient.quantity = nil
    assert_not @ingredient.valid?, 'saved ingredient without a quantity'
    assert_equal "can't be blank", @ingredient.errors[:quantity][0]
  end

  test 'save a valid ingredient' do
    assert @ingredient.save
  end

  test 'not save an invalid ingredient' do
    @ingredient.name = nil
    assert_not @ingredient.save
  end

  test 'invalid ingredient without recipe' do
    @ingredient.recipe = nil
    assert_not @ingredient.valid?
  end
end
