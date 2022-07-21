# frozen_string_literal: true

class RecipesController < ApplicationController
  before_action :set_recipe, only: %i[show edit update destroy add_step delete_image]

  # GET /recipes or /recipes.json
  def index
    @recipes = Recipe.with_image
  end

  # GET /recipes/1 or /recipes/1.json
  def show; end

  # GET /recipes/new
  def new
    @recipe = Recipe.new
  end

  # GET /recipes/1/edit
  def edit; end

  # POST /recipes or /recipes.json
  def create
    @recipe = Recipe.new(recipe_params)

    if @recipe.save
      redirect_to recipe_url(@recipe), notice: 'Recipe was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /recipes/1 or /recipes/1.json
  def update
    if @recipe.update(recipe_params)
      redirect_to recipe_url(@recipe), notice: 'Recipe was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /recipes/1 or /recipes/1.json
  def destroy
    @recipe.destroy

    redirect_to recipes_url, notice: 'Recipe was successfully destroyed.'
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

  # Only allow a list of trusted parameters through.
  def recipe_params
    params.require(:recipe).permit(:name, :body, :image, recipes_ingredients_attributes: %i[ingredient_id quantity],
                                                         steps_attributes:               %i[description order body duration],
                                                         tags_attributes:                %i[name])
  end
end
