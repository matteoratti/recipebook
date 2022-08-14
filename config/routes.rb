# frozen_string_literal: true

Rails.application.routes.draw do
  concern :autocompletable do
    get :autocomplete, on: :collection
  end

  concern :image_deletable do
    member do
      delete :delete_image
    end
  end

  concern :likeable do
    resources :likes, only: %i[create destroy]
  end

  devise_for :users

  resources :recipes, concerns: %i[likeable autocompletable], only: %i[]

  resources :users, only: %i[], concerns: %i[likeable], shallow: true do
    resources :recipes, concerns: %i[image_deletable] do
      resources :steps do
        post :add_ingredient
      end
    end
  end

  resources :steps, concerns: %i[likeable], only: %i[]
  resources :ingredients, concerns: %i[autocompletable], only: %i[]

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'recipes#index'
end
