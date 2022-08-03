# frozen_string_literal: true

require 'test_helper'

class LikesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user1 = users(:user1)
    @user2 = users(:user2)
    @recipe1 = recipes(:carbonara)
    @step1 = steps(:one)
  end

  test 'signed in user should like a step' do
    sign_in @user1

    assert_difference('Like.count') do
      post step_likes_url(@step1)
    end

    assert_response :success
  end

  test 'signed in user should unlike a step' do
    sign_in @user1

    user1_likes_step1 = Like.create(user: @user1, likeable: @step1)

    assert_difference('Like.count', -1) do
      delete step_like_url(@step1, user1_likes_step1)
    end

    assert_response :success
  end

  test 'signed out user should not unlike a step' do
    sign_in @user1

    user1_likes_step1 = Like.create(user: @user1, likeable: @step1)

    sign_out @user1

    assert_no_difference('Like.count') do
      delete step_like_url(@step1, user1_likes_step1)
    end

    assert_response :redirect

    assert_redirected_to new_user_session_path
  end

  test 'signed out user should not create a step like' do
    sign_out @user1

    assert_no_difference('Like.count') do
      post step_likes_url(@step1)
    end

    assert_response :redirect

    assert_redirected_to new_user_session_path
  end

  test 'signed in user should like a recipe' do
    sign_in @user1

    assert_difference('Like.count') do
      post recipe_likes_url(@recipe1)
    end

    assert_response :success
  end

  test 'signed in user should unlike a recipe' do
    sign_in @user1

    user1_likes_recipe1 = Like.create(user: @user1, likeable: @recipe1)

    assert_difference('Like.count', -1) do
      delete recipe_like_url(@recipe1, user1_likes_recipe1)
    end

    assert_response :success
  end

  test 'signed out user should not unlike a recipe' do
    sign_in @user1

    user1_likes_recipe1 = Like.create(user: @user1, likeable: @recipe1)

    sign_out @user1

    assert_no_difference('Like.count') do
      delete recipe_like_url(@recipe1, user1_likes_recipe1)
    end

    assert_response :redirect

    assert_redirected_to new_user_session_path
  end

  test 'signed out user should not create a recipe like' do
    sign_out @user1

    assert_no_difference('Like.count') do
      post recipe_likes_url(@recipe1)
    end

    assert_response :redirect

    assert_redirected_to new_user_session_path
  end

  test 'many signed in users can like the same recipe' do
    sign_in @user1

    assert_difference('Like.count') do
      post recipe_likes_url(@recipe1)
    end

    assert_response :success

    sign_in @user2

    assert_difference('Like.count') do
      post recipe_likes_url(@recipe1)
    end

    assert_response :success

    assert @user1.liked.exists?(likeable: @recipe1)
    assert @user2.liked.exists?(likeable: @recipe1)
  end

  test 'many signed in users can like the same step' do
    sign_in @user1

    assert_difference('Like.count') do
      post step_likes_url(@step1)
    end

    assert_response :success

    sign_in @user2

    assert_difference('Like.count') do
      post step_likes_url(@step1)
    end

    assert_response :success

    assert @user1.liked.exists?(likeable: @step1)
    assert @user2.liked.exists?(likeable: @step1)
  end
end
