# frozen_string_literal: true

class RecipesController < ApplicationController
  before_action :set_user, only: %i[new create]
  before_action :set_recipe, only: %i[show edit update destroy add_step delete_image archive publish]
  before_action :authenticate_user!, only: %i[new create edit update destroy archive publish user_recipes]
  before_action :authorize_recipe, only: %i[edit update destroy archive publish]

  include Logify
  after_action :logify_action, only: %i[create update destroy publish archive]

  include Autocompletable

  # GET /recipes or /recipes.json
  def index
    @recipes = Recipe.published.with_image.with_steps
    @recipes = Recipe.published.filter_by_name(params[:q]).with_image.with_steps if params[:q]
  end

  # GET /user/:id/my_recipes or /recipes.json
  def my_recipes
    @recipes = current_user.recipes.with_image.with_steps
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
      @notify_to = @recipe.user.followers

      redirect_to recipe_url(@recipe), notice: 'Recipe was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /recipes/1 or /recipes/1.json
  def update
    if @recipe.update(recipe_params)
      @notify_to = @recipe.user.followers

      redirect_to recipe_url(@recipe), notice: 'Recipe was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /recipes/1 or /recipes/1.json
  def destroy
    return unless @recipe.destroy

    redirect_to recipes_url, notice: 'Recipe was successfully destroyed.'
  end

  def publish
    redirect_to recipe_url(@recipe), notice: 'Recipe has been published.' if @recipe.published!
  end

  def archive
    redirect_to recipe_url(@recipe), notice: 'Recipe has been archived.' if @recipe.archive!
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
    @user = User.find(params[:user_id])
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
