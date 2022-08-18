# frozen_string_literal: true

class ActivityLog < ApplicationRecord
  belongs_to :activity_type
  belongs_to :target, polymorphic: true
  belongs_to :actor, class_name: :User, foreign_key: 'user_id'

  has_many :notifications, dependent: :destroy
  has_many :receivers, through: :notifications

  serialize :changed_data, Hash

  scope :with_actor,         -> { includes(:user).references(:user) }
  scope :with_activity_type, -> { includes(:activity_type) }
end
