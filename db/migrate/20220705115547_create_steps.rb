# frozen_string_literal: true

class CreateSteps < ActiveRecord::Migration[7.0]
  def change
    create_table :steps do |t|
      t.references :recipe, null: false, foreign_key: true
      t.string :description
      t.integer :order
      t.text :body
      t.integer :duration

      t.timestamps
    end
  end
end
