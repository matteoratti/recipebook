# frozen_string_literal: true

module HasLikes
  def self.included(base)
    base.class_eval do
      has_many :likes, as: :likeable, dependent: :destroy
    end
  end
end
