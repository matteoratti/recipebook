# frozen_string_literal: true

require 'test_helper'

class RecipeTest < ActiveSupport::TestCase
  def setup
    @recipe = Recipe.new(name: 'carbonara', body: 'si fa con le uova')
  end

  test 'valid recipe' do
    assert @recipe.valid?
  end

  test 'invalid without name' do
    @recipe.name = nil
    assert_not @recipe.valid?, 'saved recipe without a name'
    assert_not_nil @recipe.errors[:name], 'no validation error for recipe present'
  end

  test 'invalid without body' do
    @recipe.body = nil
    assert_not @recipe.valid?, 'saved recipe without a body'
    assert_equal "can't be blank", @recipe.errors[:body][0]
  end

  test 'save a valid recipe' do
    assert @recipe.save
  end

  test 'not save an invalid recipe' do
    @recipe.name = nil
    assert_not @recipe.save
  end
end
