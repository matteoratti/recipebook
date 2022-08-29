# frozen_string_literal: true

module StepIngredientsHelper
  def add_ingredient_button(form, index)
    form.submit 'Add Ingredient',
                class:          'btn btn-sm btn-primary',
                formaction:     step_ingredient_path(index.to_i + 1),
                formmethod:     :post,
                formnovalidate: true,
                id:             'add-ingredient'
  end
end
