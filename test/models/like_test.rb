# frozen_string_literal: true

require 'test_helper'

class LikeTest < ActiveSupport::TestCase
  def setup
    @user1_likes_recipe1 = Like.new(user: users(:user1), likeable: recipes(:carbonara))
  end

  test 'assert a valid like' do
    assert @user1_likes_recipe1.valid?
  end

  test 'invalid without user id' do
    @user1_likes_recipe1.user = nil

    @user1_likes_recipe1.save

    assert_equal ['User must exist'], @user1_likes_recipe1.errors.full_messages
  end

  test 'invalid without likeable' do
    @user1_likes_recipe1.likeable = nil

    @user1_likes_recipe1.save

    assert_equal ['Likeable must exist'], @user1_likes_recipe1.errors.full_messages
  end

  test 'user should give one like to one recipe' do
    @user1_likes_recipe1.save

    user1_likes_recipe1_again = Like.new(user: users(:user1), likeable: recipes(:carbonara))
    assert_not user1_likes_recipe1_again.save

    assert_equal ['User already liked this resource'], user1_likes_recipe1_again.errors.full_messages
  end
end
