# frozen_string_literal: true

class AddUserLikeableUniqueIndexesToLikes < ActiveRecord::Migration[7.0]
  def change
    add_index :likes, %i[user_id likeable_id likeable_type], unique: true
  end
end
