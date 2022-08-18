# frozen_string_literal: true

class Notification < ApplicationRecord
  belongs_to :receiver, class_name: :User, foreign_key: 'user_id'
  belongs_to :activity_log

  scope :with_log, -> { includes(activity_log: %i[actor activity_type]) }

  scope :unviewed, -> { where(viewed: false) }
  scope :latest,   -> { order(:created_at) }

  after_create_commit :broadcast_notification
  after_save_commit :notifications_count_update

  private

  def broadcast_notification
    broadcast_prepend_to "broadcast_to_user_#{user_id}", partial: 'shared/notification', locals: { notification: self }, target: 'notifications-list'
  end

  def notifications_count_update
    broadcast_replace_to "broadcast_to_user_#{user_id}",
                         target:  'notifications-count',
                         partial: 'shared/notifications-count',
                         locals:  { count: User.find(user_id).notifications.unviewed.count }
  end
end
