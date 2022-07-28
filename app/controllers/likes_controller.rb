# frozen_string_literal: true

class LikesController < ApplicationController
  before_action :authenticate_user!, only: %i[create]
  before_action :set_likeable, only: %i[create]

  def create
    @like = Like.new(user: current_user, likeable: @likeable)

    if @like.save
      render formats: :turbo_stream
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_likeable
    @likeable = if params.include?(:user_id)
                  User.find(params[:user_id])
                elsif params.include?(:recipe_id)
                  Recipe.find(params[:recipe_id])
                else
                  raise UnprocessableEntityError, :context_missing
                end
  end
end
