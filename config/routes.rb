# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, concerns: %i[likeable]

  concern :image_deletable do
    member do
      delete :delete_image
    end
  end

  concern :likeable do
    resources :likes, only: %i[create destroy]
  end

  resources :recipes, concerns: %i[image_deletable likeable] do
    resources :steps
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'recipes#index'
end
