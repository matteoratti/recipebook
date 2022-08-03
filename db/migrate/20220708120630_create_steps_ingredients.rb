# frozen_string_literal: true

class CreateStepsIngredients < ActiveRecord::Migration[7.0]
  def change
    create_table :steps_ingredients do |t|
      t.references :step, null: false, foreign_key: true
      t.references :ingredient, null: false, foreign_key: true
      t.integer :quantity
      t.string :ingredient_name
      t.string :step_description

      t.timestamps
    end
  end
end
