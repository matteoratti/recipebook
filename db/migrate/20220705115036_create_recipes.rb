# frozen_string_literal: true

class CreateRecipes < ActiveRecord::Migration[7.0]
  def change
    create_table :recipes do |t|
      t.string :name
      t.text :body
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
