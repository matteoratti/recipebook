# frozen_string_literal: true

require 'test_helper'

class RecipesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:user1)
    @recipe = recipes(:carbonara)
  end

  test 'should get index' do
    get user_recipes_url(@user)
    assert_response :success
  end

  test 'should get new' do
    get new_user_recipe_url(@user)
    assert_response :success
  end

  test 'should create recipe' do
    assert_difference('Recipe.count') do
      post user_recipes_url(@user), params: { recipe: { body: @recipe.body, name: @recipe.name } }
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

    assert_redirected_to user_recipes_url(@user)
  end

  test 'invalid recipe creation' do
    assert_no_difference('Recipe.count') do
      post user_recipes_url(@user), params: { recipe: { body: @recipe.body, name: nil } }
    end

    assert_response 422
  end

  test 'invalid recipe update' do
    patch recipe_url(@recipe), params: { recipe: { body: @recipe.body, name: nil } }
    assert_response 422
  end

  test 'create a recipe with steps' do
    steps = [
      { description: 'bollire uova', order: 1, body: 'this is a body', duration: 1200 },
      { description: 'pelare patate', order: 2, body: 'this is a body for potatoes', duration: 600 }
    ]

    assert_difference('Recipe.count') do
      post user_recipes_url(@user), params: { recipe: { body: @recipe.body, name: @recipe.name, steps_attributes: steps } }
    end

    assert_equal steps[0],
                 Recipe.last.steps.first.attributes.symbolize_keys.except(:id, :created_at, :updated_at, :recipe_id)
    assert_redirected_to recipe_url(Recipe.last)
  end

  test 'create a recipe with tags' do
    tags = [
      { name: 'cucina italiana' },
      { name: 'gluten free' }
    ]

    assert_difference('Recipe.count') do
      post user_recipes_url(@user), params: { recipe: { body: @recipe.body, name: @recipe.name, tags_attributes: tags } }
    end

    assert_equal tags[0][:name], Recipe.last.tags.first.name
    assert_redirected_to recipe_url(Recipe.last)
  end

  test 'create a recipe with an image' do
    assert_difference('Recipe.count') do
      post user_recipes_url(@user), params: { recipe: { body: @recipe.body, name: @recipe.name, image: fixture_file_upload('pesto.jpg', 'fixtures/files') } }
    end

    assert Recipe.last.image.attached?
  end

  test 'delete only recipe image' do
    post user_recipes_url(@user), params: { recipe: { body: @recipe.body, name: @recipe.name, image: fixture_file_upload('pesto.jpg', 'fixtures/files') } }

    delete delete_image_recipe_path(Recipe.last)

    assert Recipe.last.present?

    assert_not Recipe.last.image.attached?

    assert_redirected_to recipe_url(Recipe.last)
  end
end
