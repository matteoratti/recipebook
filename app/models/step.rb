# frozen_string_literal: true

class Step < ApplicationRecord
  belongs_to :recipe

  has_many :step_ingredients, dependent: :destroy
  has_many :ingredients, through: :step_ingredients

  include HasLikes

  validates :description, :body, :order, presence: true

  accepts_nested_attributes_for :step_ingredients
end
