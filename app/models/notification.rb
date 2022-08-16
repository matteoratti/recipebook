# frozen_string_literal: true

class Notification < ApplicationRecord
  belongs_to :receiver, class_name: :User, foreign_key: 'user_id'
  belongs_to :activity_log

  after_create_commit -> { broadcast_prepend_to "broadcast_to_user_#{user_id}", partial: 'shared/notification', locals: { notification: self }, target: 'notification' }
end
