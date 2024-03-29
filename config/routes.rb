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

  resources :recipes, concerns: %i[likeable autocompletable], only: %i[index]
  resources :users, concerns: %i[likeable], only: %i[]

  get 'users/:user_id/user_recipes', to: 'recipes#user_recipes', as: 'all_user_recipes'

  resources :users, only: %i[], concerns: %i[likeable], shallow: true do
    member do
      get :my_recipes, to: 'recipes#my_recipes'
    end
    resources :recipes, concerns: %i[image_deletable] do
      member do
        patch :publish
        patch :archive
      end
      resources :steps
    end
  end

  resources :step_ingredients, only: [], param: :index do
    member do
      delete '(:id)' => 'step_ingredients#destroy', as: ''
      post '/' => 'step_ingredients#create'
    end
  end

  resources :steps, concerns: %i[likeable], only: %i[]
  resources :ingredients, concerns: %i[autocompletable], only: %i[]

  resources :notifications, only: [:index] do
    patch :view_all, on: :collection

    member do
      patch :view
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'recipes#index'
end
