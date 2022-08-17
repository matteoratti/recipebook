# frozen_string_literal: true

class SendNotificationJob < ApplicationJob
  queue_as :default

  def perform(activity_log, receivers)
    receivers.map { |id| activity_log.notifications.build(user_id: id).save }
  end
end
