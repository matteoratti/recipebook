# frozen_string_literal: true

class IngredientsController < ApplicationController
  include Autocompletable

  private

  def default_scope
    Ingredient.all
  end
end
