# frozen_string_literal: true

class ActivityLog < ApplicationRecord
  belongs_to :activity_type
  belongs_to :target, polymorphic: true
  belongs_to :actor, class_name: :User, foreign_key: 'user_id'

  has_many :notifications, dependent: :destroy
  has_many :receivers, through: :notifications

  # now you can use 'self.name' instead 'self.activity_type.name'
  delegate :name, to: :activity_type

  serialize :changed_data, Hash

  scope :with_actor,         -> { includes(:user).references(:user) }
  scope :with_activity_type, -> { includes(:activity_type) }
end
