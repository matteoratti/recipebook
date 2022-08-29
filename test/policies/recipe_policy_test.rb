# frozen_string_literal: true

require 'test_helper'

class RecipePolicyTest < ActiveSupport::TestCase
  def setup
    @user1 = users(:user1)
    @user2 = users(:user2)
    @user3 = users(:user3)
    @recipe1 = recipes(:carbonara)
  end

  test 'user should not likes own recipe' do
    refute_permit @user1, @recipe1, :like
  end

  test 'guest should not likes a recipe' do
    refute_permit nil, @recipe1, :like
  end

  test 'not owner user should likes a recipe' do
    assert_permit @user2, @recipe1, :like
  end
end
