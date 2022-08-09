# frozen_string_literal: true

require 'test_helper'

class RecipeTest < ActiveSupport::TestCase
  def setup
    @recipe = Recipe.new(name: 'carbonara', body: 'si fa con le uova')
  end

  test 'valid recipe' do
    assert @recipe.valid?
  end

  test 'recipe should be draft by default' do
    assert @recipe.status, 'draft'
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

  test 'when destroy recipe, destroy all tags too' do
    @recipe.tags.build([{ name: 'ricette italiane' }, { name: 'ricette popolari' }])
    @recipe.save

    assert @recipe.destroy
    assert_empty @recipe.tags
  end

  test 'get recipe ingredient list' do
    step_ingredient_1 = StepIngredient.create(step: steps(:one), ingredient: ingredients(:uova), quantity: 5)
    step_ingredient_2 = StepIngredient.create(step: steps(:two), ingredient: ingredients(:burro), quantity: 10)

    StepIngredient.create(step: steps(:two), ingredient: ingredients(:burro), quantity: 30)

    Step.create(recipe: @recipe, description: 'sbattere le uova', order: 1, body: 'this is a body', duration: 1200)
    Step.create(recipe: @recipe, description: 'aggiungere burro', order: 2, body: 'this is a burro', duration: 10)

    # new step with same ingredient
    Step.create(recipe: @recipe, description: 'aggiungere burro', order: 2, body: 'this is a burro', duration: 10)

    assert @recipe.recipe_step_ingredients.instance_of? PG::Result
    assert_not @recipe.recipe_step_ingredients.num_tuples.zero?

    assert_equal step_ingredient_1.ingredient.name, 'uova'
    assert_equal step_ingredient_2.ingredient.name, 'burro'

    recipe_ingredients = @recipe.recipe_step_ingredients.to_a

    assert_not recipe_ingredients.uniq!

    burro_ingredient = recipe_ingredients.find {|x| x['name'] == 'burro'}
    assert_equal burro_ingredient['sum'], 40
  end
end
