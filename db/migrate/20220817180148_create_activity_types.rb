# frozen_string_literal: true

class CreateActivityTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :activity_types do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
