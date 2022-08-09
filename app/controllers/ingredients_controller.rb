# frozen_string_literal: true

class IngredientsController < ApplicationController
  def autocomplete
    @search_results = Ingredient.ingredients_from_search(params[:q])
    render partial: 'autocomplete', formats: :html
  end
end
