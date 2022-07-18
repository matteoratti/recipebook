# frozen_string_literal: true

require 'test_helper'

class IngredientTest < ActiveSupport::TestCase
  def setup
    # take recipe from recipes fixture
    @ingredient = Ingredient.new(name: 'uova', unit_type: :unit)
  end

  test 'valid ingredient' do
    assert @ingredient.valid?
  end

  test 'invalid without name' do
    @ingredient.name = nil
    assert_not @ingredient.valid?, 'saved ingredient without a name'
    assert_not_nil @ingredient.errors[:name], 'no validation error for ingredient present'
  end

  test 'invalid without unit type' do
    @ingredient.unit_type = nil
    assert_not @ingredient.valid?, 'saved ingredient without a quantity'
    assert_equal "Unit type can't be blank", @ingredient.errors.full_messages.first
  end

  test 'save a valid ingredient' do
    assert @ingredient.save
  end

  test 'not save an invalid ingredient' do
    @ingredient.name = nil
    assert_not @ingredient.save
  end

  test 'when destroy ingredient, destroy all tags too' do
    @ingredient.save
    tag1 = Tag.create(name: 'ricette italiane', taggable: @ingredient)
    tag2 = Tag.create(name: 'ricette popolari', taggable: @ingredient)

    assert @ingredient.destroy
    assert_raise(ActiveRecord::RecordNotFound) { tag1.reload tag2.reload }
  end
end
