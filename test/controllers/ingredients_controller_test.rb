# frozen_string_literal: true

require 'test_helper'

class IngredientsControllerTest < ActionDispatch::IntegrationTest
  test 'autocomplete response' do
    get autocomplete_ingredients_path, params: { q: 'burro' }
    assert_response :success
  end
end
