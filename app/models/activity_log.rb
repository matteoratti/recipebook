# frozen_string_literal: true

class ActivityLog < ApplicationRecord
  belongs_to :item, polymorphic: true
  belongs_to :actor, class_name: :User, foreign_key: 'user_id'

  has_many :notifications, dependent: :destroy
  has_many :receivers, through: :notifications

  scope :with_actor, -> { includes(:user).references(:user) }

  after_create :notify, if: :notificable

  attr_accessor :receivers

  def notify
    SendNotificationJob.perform_later self, receivers
  end
end
