# frozen_string_literal: true

class Step < ApplicationRecord
  belongs_to :recipe

  include HasLikes

  validates :description, :body, :order, presence: true
end
