# frozen_string_literal: true

class CreateActivityLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :activity_logs do |t|
      t.references :target, polymorphic: true
      t.references :user, null: true, foreign_key: true
      t.string :activity_type
      t.string :changed_data

      t.timestamps
    end
  end
end
