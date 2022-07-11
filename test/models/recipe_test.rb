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
    assert_equal "Body can't be blank", @recipe.errors.full_messages.first
  end

  test 'save a valid recipe' do
    assert @recipe.save
  end

  test 'not save an invalid recipe' do
    @recipe.name = nil
    assert_not @recipe.save
  end

  test 'not save if any :presence validation is missing' do
    Recipe.validators.each do |v|
      next unless v.kind == :presence

      v.attributes.each do |attr|
        @recipe[attr] = nil
        assert_not @recipe.save
      end
    end
  end
end
