# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper_method :like_of_current_user
  layout :layout_by_resource

  protected

  def layout_by_resource
    if devise_controller?
      'devise'
    else
      'application'
    end
  end

  private

  def like_of_current_user(likeable)
    current_user.liked.find_by(likeable: likeable)
  end
end
