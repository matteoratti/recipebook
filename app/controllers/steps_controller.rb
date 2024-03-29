# frozen_string_literal: true

class StepsController < ApplicationController
  before_action :set_step, only: %i[edit update destroy]
  before_action :set_recipe, only: %i[index new create update destroy]
  before_action :authenticate_user!, only: %i[new create edit update destroy]
  before_action :authorize_step, only: %i[edit update destroy]

  include Logify
  after_action :logify_action, only: %i[create update destroy]

  def new
    @step = Step.new(recipe: @recipe)
    authorize_step
    @step.step_ingredients.build&.build_ingredient
  end

  def edit; end

  def create
    @step = @recipe.steps.build(step_params)

    authorize_step

    if @step.save
      @notify_to = @step.recipe.followers
      render formats: :turbo_stream
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @step.update(step_params)
      @notify_to = @step.recipe.followers

      render formats: :turbo_stream
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    return unless @step.destroy

    @notify_to = @step.recipe.followers

    render formats: :turbo_stream
  end

  private

  def set_recipe
    @recipe = params.include?(:recipe_id) ? Recipe.find(params[:recipe_id]) : @step.recipe
  end

  def set_step
    @step = Step.find(params[:id])
  end

  def authorize_step
    authorize @step
  end

  def step_params
    params.require(:step).permit(:description, :body, :order, :duration, :id,
                                 step_ingredients_attributes: [:_destroy, :id, :quantity, {
                                   ingredient_attributes: %i[name unit_type id]
                                 }])
  end
end
