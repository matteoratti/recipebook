# frozen_string_literal: true

class Recipe < ApplicationRecord
  has_many :ingredients, dependent: :destroy
  has_many :steps, dependent: :destroy

  validates :name, :body, presence: true

  accepts_nested_attributes_for :ingredients, :steps
end
