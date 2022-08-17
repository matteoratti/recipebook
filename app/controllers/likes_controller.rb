# frozen_string_literal: true

class LikesController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]
  before_action :set_likeable, only: %i[create destroy]
  before_action :set_like, only: %i[destroy]

  def create
    @like = Like.new(user: current_user, likeable: @likeable)

    if @like.save
      ActivityLog.create(actor: current_user, item: @likeable, notificable: true, activity_type: 'add_like', receivers: [@receiver])
      render :like, formats: :turbo_stream
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    return unless @like.destroy

    ActivityLog.create(actor: current_user, item: @likeable, activity_type: 'remove_like')
    render :like, formats: :turbo_stream
  end

  private

  def set_like
    @like = Like.find(params[:id])
  end

  def set_likeable
    if params.include?(:user_id)
      @likeable = User.find(params[:user_id])
      @receiver = @likeable.id
    elsif params.include?(:recipe_id)
      @likeable = Recipe.find(params[:recipe_id])
      @receiver = @likeable.user_id
    elsif params.include?(:step_id)
      @likeable = Step.find(params[:step_id])
      @receiver = @likeable.recipe.user_id
    else
      raise UnprocessableEntityError, :context_missing
    end
  end
end
