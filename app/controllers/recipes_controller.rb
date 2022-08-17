# frozen_string_literal: true

class RecipesController < ApplicationController
  before_action :set_user, only: %i[index new edit create destroy]
  before_action :set_recipe, only: %i[show edit update destroy add_step delete_image]
  before_action :authenticate_user!, :authorize_recipe, only: %i[new create edit update destroy]

  include Autocompletable

  # GET /recipes or /recipes.json
  def index
    @recipes = if params[:q]
                 Recipe.filter_by_name(params[:q]).with_image.with_steps
               else
                 Recipe.with_image.with_steps
               end
  end

  # GET /recipes/1 or /recipes/1.json
  def show
    @step = Step.new(recipe_id: @recipe.id)
    @recipe_ingredients = @recipe.recipe_step_ingredients
  end

  # GET /recipes/new
  def new
    @recipe = Recipe.new
  end

  # GET /recipes/1/edit
  def edit; end

  # POST /recipes or /recipes.json
  def create
    @recipe = @user.recipes.build(recipe_params)

    if @recipe.save
      receivers_ids = @recipe.user.likes.pluck(:user_id)
      ActivityLog.create(actor: current_user, item: @recipe, notificable: true, activity_type: 'create_recipe', receivers: receivers_ids)
      redirect_to recipe_url(@recipe), notice: 'Recipe was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /recipes/1 or /recipes/1.json
  def update
    if @recipe.update(recipe_params)
      receivers_ids = @recipe.likes.pluck(:user_id)
      ActivityLog.create(actor: current_user, item: @recipe, notificable: true, activity_type: 'update_recipe', receivers: receivers_ids)
      redirect_to recipe_url(@recipe), notice: 'Recipe was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /recipes/1 or /recipes/1.json
  def destroy
    return unless @recipe.destroy

    ActivityLog.create(actor: current_user, item: @recipe, activity_type: 'remove_recipe')
    redirect_to user_recipes_url(@user), notice: 'Recipe was successfully destroyed.'
  end

  def delete_image
    @recipe.image.purge if @recipe.image.attached?

    redirect_to recipe_path(@recipe)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  def set_user
    @user = User.first
  end

  def authorize_recipe
    authorize @recipe
  end

  # Only allow a list of trusted parameters through.
  def recipe_params
    params.require(:recipe).permit(:name, :body, :image,
                                   steps_attributes: %i[description order body duration],
                                   tags_attributes:  %i[name])
  end
end
