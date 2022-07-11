# frozen_string_literal: true

class CreateRecipesIngredients < ActiveRecord::Migration[7.0]
  def change
    create_table :recipes_ingredients do |t|
      t.references :recipe, null: false, foreign_key: true
      t.references :ingredient, null: false, foreign_key: true
      t.integer :quantity
      t.string :ingredient_name
      t.string :recipe_name

      t.timestamps
    end
  end
end
