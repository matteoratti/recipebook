# frozen_string_literal: true

class StepsController < ApplicationController
  before_action :set_step, only: %i[edit update destroy]
  before_action :set_recipe, only: %i[index new create update destroy add_ingredient]

  def new
    @step = Step.new
  end

  def edit; end

  def create
    @step = @recipe.steps.build(step_params)

    if @step.save
      render formats: :turbo_stream
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @step.update(step_params)
      render formats: :turbo_stream
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    render formats: :turbo_stream if @step.destroy
  end

  def add_ingredient
    if params[:id]
      set_step
      @step.assign_attributes(step_params)

    else
      @step = Step.new(step_params.merge({ id: params[:id] }))
    end

    @step.step_ingredients.build.build_ingredient

    render :edit
  end

  private

  def set_recipe
    @recipe = params.include?(:recipe_id) ? Recipe.find(params[:recipe_id]) : @step.recipe
  end

  def set_step
    @step = Step.find(params[:id])
  end

  def step_params
    params.require(:step).permit(:description, :body, :order, :duration,
                                 step_ingredients_attributes: [:_destroy, :id, :quantity, {
                                   ingredient_attributes: %i[name unit_type]
                                 }])
  end
end
