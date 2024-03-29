# frozen_string_literal: true

class Like < ApplicationRecord
  belongs_to :user
  belongs_to :likeable, polymorphic: true

  include HasLogs

  scope :likers_ids, ->(likeable) { where(likeable:).pluck(:user_id) }

  validates :user, uniqueness: { scope: %i[likeable_id likeable_type], message: 'already liked this resource' }
end
