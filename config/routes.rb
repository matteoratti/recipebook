# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  concern :image_deletable do
    member do
      delete :delete_image
    end
  end

  resources :recipes, concerns: [:image_deletable] do
    resources :steps
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'recipes#index'
end
