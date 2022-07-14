# frozen_string_literal: true

class StepsController < ApplicationController
  before_action :set_recipe
  before_action :set_step, only: [:edit, :update, :destroy]

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

  private

  def set_recipe
    @recipe = Recipe.find(params[:recipe_id])
  end

  def set_step
    @step = @recipe.steps.find(params[:id])
  end

  def step_params
    params.require(:step).permit(:description, :order, :body, :duration)
  end
end