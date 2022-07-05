# frozen_string_literal: true

class Recipe < ApplicationRecord
  validates :name, :body, presence: true
end
