# frozen_string_literal: true

class StepsController < ApplicationController
  before_action :set_step, only: %i[edit update destroy]
  before_action :set_recipe, only: %i[index new create update destroy add_ingredient]
  before_action :authenticate_user!, only: %i[new create edit update destroy]
  before_action :authorize_step, only: %i[edit update destroy]

  def new
    @step = Step.new(recipe: @recipe)
    authorize_step
    @step.step_ingredients.build.build_ingredient
  end

  def edit; end

  def create
    @step = @recipe.steps.build(step_params)

    authorize_step

    if @step.save
      ActivityLog.create(actor: current_user, item: @step, activity_type: 'create_step')
      render formats: :turbo_stream
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @step.update(step_params)
      receivers_ids = @step.likes.pluck(:user_id)
      ActivityLog.create(actor: current_user, item: @step, notificable: true, activity_type: 'update_step', receivers: receivers_ids)
      render formats: :turbo_stream
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    return unless @step.destroy

    ActivityLog.create(actor: current_user, item: @step, activity_type: 'remove_step')
    render formats: :turbo_stream
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

  def authorize_step
    authorize @step
  end

  def step_params
    params.require(:step).permit(:description, :body, :order, :duration,
                                 step_ingredients_attributes: [:_destroy, :id, :quantity, {
                                   ingredient_attributes: %i[name unit_type]
                                 }])
  end
end
