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
    @notifications_ids = current_user.notifications.unviewed.ids
    current_user.notifications.unviewed.update_all(viewed: true) if current_user
    render formats: :turbo_stream
  end
end
