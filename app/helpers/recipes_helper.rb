# frozen_string_literal: true

module RecipesHelper
  def recipe_image(recipe)
    if recipe.image.attached?
      image_tag recipe.image, class: 'img-fluid image-card'
    else
      image_tag '/placeholder_recipe.png', class: 'img-fluid image-card'
    end
  end

  def recipe_status(status)
    tag.span status, class: 'badge bg-primary'
  end

  def recipe_duration(recipe)
    unit_time = recipe.steps.sum('duration') > 1 ? 'mins' : 'min'
    "#{recipe.steps.sum('duration')} #{unit_time}"
  end
end
