# frozen_string_literal: true

require 'test_helper'

class RecipeTest < ActiveSupport::TestCase
  def setup
    @user = users(:user1)
    @recipe = Recipe.new(user: @user, name: 'carbonara', body: 'si fa con le uova')
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
        next if attr == :user

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

  test 'query must returns only recipe ingredients from recipe steps' do
    # recipe pesto
    recipe1 = Recipe.create(user: @user, name: 'pesto', body: 'pesto body')
    recipe1_step1 = Step.create(recipe: recipe1, description: 'aggiungere basilico', order: 1, body: 'recipe1 step1 body', duration: 10)
    recipe1_ingredient = Ingredient.create(name: 'basilico', unit_type: :g)
    StepIngredient.create(step: recipe1_step1, ingredient: recipe1_ingredient, quantity: 10)

    # recipe ragu
    recipe2 = Recipe.create(user: @user, name: 'ragu', body: 'ragu body')
    recipe2_step1 = Step.create(recipe: recipe2, description: 'aggiungere manzo', order: 1, body: 'recipe 2 step1 body', duration: 20)
    recipe2_ingredient = Ingredient.create(name: 'manzo', unit_type: :g)
    StepIngredient.create(step: recipe2_step1, ingredient: recipe2_ingredient, quantity: 20)

    recipe1_step_ingredients = recipe1.recipe_step_ingredients

    assert_not(recipe1_step_ingredients.any? { |el| el['name'] == recipe2_ingredient.name })
  end

  test 'create a recipe with an user' do
    recipe1 = Recipe.create(user: @user, name: 'pesto', body: 'pesto body')
    recipe2 = Recipe.create(user: @user, name: 'frittata', body: 'pesto body')

    assert(@user.recipes.any? { |recipe| recipe['id'] == recipe1.id })
    assert(@user.recipes.any? { |recipe| recipe['id'] == recipe2.id })
  end

  test 'filter_by_name scope should returns published recipes only' do
    recipes(:carbonara).update(status: 'published')

    default_scope = Recipe.published

    results = default_scope.filter_by_name('a')

    assert results.all? { |result| result.status == 'published' }
  end
end
