# frozen_string_literal: true

class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.notifications
    @notifications.update(viewed: true)
  end

  def view
    @notification = Notification.find(params[:id])
    render formats: :turbo_stream if @notification.update(viewed: true)
  end

  def view_all
    @notifications = current_user.notifications.unviewed if current_user
    @notifications.update_all(viewed: true)
    render formats: :turbo_stream
  end
end
