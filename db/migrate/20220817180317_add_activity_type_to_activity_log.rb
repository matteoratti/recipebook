# frozen_string_literal: true

class AddActivityTypeToActivityLog < ActiveRecord::Migration[7.0]
  def up
    remove_column :activity_logs, :activity_type
    add_reference :activity_logs, :activity_type, null: false, foreign_key: true
  end

  def down
    remove_reference :activity_logs, :activity_type, index: true, foreign_key: true
    add_column :activity_logs, :activity_type, :string
  end
end
