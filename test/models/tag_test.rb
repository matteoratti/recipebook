# frozen_string_literal: true

require 'test_helper'

class TagTest < ActiveSupport::TestCase
  def setup
    @tag = Tag.new(name: 'cucina italiana', taggable: recipes(:carbonara))
  end

  test 'should be invalid without a name' do
    @tag.name = nil
    assert_not @tag.valid?
  end

  test 'should be invalid without a taggable' do
    @tag.taggable = nil

    assert_not @tag.valid?
  end

  test 'should not save without a name' do
    @tag.name = nil
    assert_not @tag.save
  end

  test 'should not save without a taggable' do
    @tag.taggable = nil

    assert_not @tag.save
  end

  test 'should be valid with all fields' do
    assert @tag.valid?
  end

  test 'should save with all fields' do
    assert @tag.save
  end


end

