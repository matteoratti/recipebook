# frozen_string_literal: true

class ActivityLog < ApplicationRecord
  belongs_to :item, polymorphic: true
  belongs_to :sender, class_name: :User, foreign_key: 'user_id'

  has_many :notifications, dependent: :destroy
  has_many :receivers, through: :notifications

  after_create :notify, if: :notificable

  attr_accessor :receivers

  def notify
    receivers.map { |id| notifications.build(user_id: id).save }
  end
end
