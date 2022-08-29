# frozen_string_literal: true

require 'test_helper'

class StepPolicyTest < ActiveSupport::TestCase
  def setup
    @user1 = users(:user1)
    @user2 = users(:user2)
    @user3 = users(:user3)
    @recipe1 = recipes(:carbonara)
    @step1 = steps(:one)
  end

  test 'user should not likes own step' do
    refute_permit @user1, @step1, :like
  end

  test 'guest should not likes a step' do
    refute_permit nil, @step1, :like
  end

  test 'not owner user should likes a step' do
    assert_permit @user2, @step1, :like
  end
end
