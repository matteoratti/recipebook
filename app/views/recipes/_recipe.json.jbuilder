# frozen_string_literal: true

json.extract! recipe, :id, :name, :body, :created_at
json.url recipe_url(recipe, format: :json)
