# frozen_string_literal: true

Rails.application.routes.draw do
  post 'recipes/:id/delete_image', to: 'recipes#delete_image', as: :delete_recipe_image
  resources :recipes do
    resources :steps
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'recipes#index'
end
