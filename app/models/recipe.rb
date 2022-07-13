# frozen_string_literal: true

class Recipe < ApplicationRecord
  enum status: { draft: 0, published: 1, archived: 2 }

  has_many :recipes_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipes_ingredients

  has_many :steps, dependent: :destroy
  has_many :tags, as: :taggable, dependent: :destroy

  scope :with_steps,       -> { includes(:steps).references(:steps) }
  scope :with_ingredients, -> { includes(:ingredients).references(:ingredients) }

  scope :drafted,   -> { where(status: :draft) }
  scope :published, -> { where(status: :published) }
  scope :archived,  -> { where(status: :archived) }

  validates :name, :body, presence: true

  accepts_nested_attributes_for :recipes_ingredients, :steps, :tags
end
