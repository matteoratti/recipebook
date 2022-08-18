# frozen_string_literal: true

module HasLikes
  def self.included(base)
    base.class_eval do
      has_many :likes, as: :likeable, dependent: :destroy

      def followers
        likes.pluck(:user_id)
      end
    end
  end
end
