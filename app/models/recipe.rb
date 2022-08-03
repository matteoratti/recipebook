# frozen_string_literal: true

class Recipe < ApplicationRecord
  enum status: { draft: 0, published: 1, archived: 2 }

  has_many :steps, dependent: :destroy
  has_many :tags, as: :taggable, dependent: :destroy

  include HasLikes

  has_one_attached :image

  scope :with_steps,       -> { includes(:steps).references(:steps) }
  scope :with_ingredients, -> { includes(:ingredients).references(:ingredients) }
  scope :with_image,       -> { includes(image_attachment: :blob) }

  scope :drafted,   -> { where(status: :draft) }
  scope :published, -> { where(status: :published) }
  scope :archived,  -> { where(status: :archived) }

  validates :name, :body, presence: true

  accepts_nested_attributes_for :steps, :tags
end
