# frozen_string_literal: true

class SendNotificationJob < ApplicationJob
  queue_as :default

  def perform(activity_log, receivers)
    notification = Notification.find_by(activity_log: activity_log)
    
    return true if notification
    
    receivers.map { |id| activity_log.notifications.build(user_id: id).save }
  end
end
