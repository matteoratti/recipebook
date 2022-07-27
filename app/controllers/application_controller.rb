# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper_method :current_user_liked?
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

  def current_user_liked?(likeable)
    current_user.liked.exists?(likeable: likeable)
  end
end
