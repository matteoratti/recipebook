# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  include HasLikes

  has_many :liked, class_name: 'Like', dependent: :nullify
  has_many :logs, class_name: 'ActivityLog', as: :actor, dependent: :delete_all
  has_many :recipes, dependent: :destroy
  has_many :notifications, dependent: :destroy

  def logify(target, action, receivers = nil, changed_data = nil)
    activity_type = ActivityType.find_or_create_by(name: action)

    activity_log = ActivityLog.create(actor: self, target:, activity_type_id: activity_type.id, changed_data:)

    SendNotificationJob.perform_later(activity_log, receivers) if receivers
  end
end
