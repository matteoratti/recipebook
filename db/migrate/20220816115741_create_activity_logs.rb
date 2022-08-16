# frozen_string_literal: true

class CreateActivityLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :activity_logs do |t|
      t.references :item, polymorphic: true
      t.references :user, null: true, foreign_key: true
      t.boolean :notificable
      t.string :activity_type

      t.timestamps
    end
  end
end
