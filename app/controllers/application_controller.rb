# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper_method :current_likeable
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

  def current_likeable(likeable)
    current_user.liked.find_by_likeable_id(likeable)
  end
end
