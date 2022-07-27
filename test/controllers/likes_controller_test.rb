# frozen_string_literal: true

require 'test_helper'

class LikesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user1 = users(:user1)
    @recipe1 = recipes(:carbonara)
  end

  test 'signed in user should create a recipe like' do
    sign_in @user1

    assert_difference('Like.count') do
      post recipe_likes_url(@recipe1)
    end

    assert_response :success
  end

  test 'signed out user should not create a recipe like' do
    sign_out @user1

    assert_no_difference('Like.count') do
      post recipe_likes_url(@recipe1)
    end

    assert_response :redirect

    assert_redirected_to new_user_session_path
  end
end
