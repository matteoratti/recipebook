# frozen_string_literal: true

class LikesController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]
  before_action :set_likeable, only: %i[create destroy]
  before_action :set_like, only: %i[destroy]

  def create
    @like = Like.new(user: current_user, likeable: @likeable)

    if @like.save
      render :like, formats: :turbo_stream
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    render :like, formats: :turbo_stream if @like.destroy
  end

  private

  def set_like
    @like = Like.find(params[:id])
  end

  def set_likeable
    @likeable = if params.include?(:user_id)
                  User.find(params[:user_id])
                elsif params.include?(:recipe_id)
                  Recipe.find(params[:recipe_id])
                elsif params.include?(:step_id)
                  Step.find(params[:step_id])
                else
                  raise UnprocessableEntityError, :context_missing
                end
  end
end
