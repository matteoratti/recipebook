# frozen_string_literal: true

class Step < ApplicationRecord
  belongs_to :recipe

  validates :description, :body, :order, presence: true
end
