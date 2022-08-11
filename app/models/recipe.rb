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

  def recipe_step_ingredients
    return if steps.empty?

    ids = steps.ids
    sql = "
      SELECT SUM(step_ingredients.quantity), ingredients.unit_type, ingredients.name
      FROM step_ingredients
      INNER JOIN ingredients
      ON step_ingredients.ingredient_id = ingredients.id
      WHERE step_ingredients.step_id IN (#{ids.join(',')})
      GROUP BY ingredients.unit_type, ingredients.name
    "
    ActiveRecord::Base.connection.exec_query(sql)
  end
end
