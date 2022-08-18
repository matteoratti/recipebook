# frozen_string_literal: true

class LikesController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]
  before_action :set_likeable_and_receiver, only: %i[create destroy]
  before_action :set_like, only: %i[destroy]

  include Logify
  after_action :logify_action, only: %i[create destroy]

  def create
    @like = Like.new(user: current_user, likeable: @likeable)

    if @like.save
      @notify_to = [@receiver]

      render :like, formats: :turbo_stream
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    return unless @like.destroy

    @notify_to = [@receiver]

    render :like, formats: :turbo_stream
  end

  private

  def set_like
    @like = Like.find(params[:id])
  end

  def set_likeable_and_receiver
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
