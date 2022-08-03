# frozen_string_literal: true

class Step < ApplicationRecord
  belongs_to :recipe

  has_many :steps_ingredients, dependent: :destroy
  has_many :ingredients, through: :steps_ingredients

  include HasLikes

  validates :description, :body, :order, presence: true

  accepts_nested_attributes_for :steps_ingredients
end
