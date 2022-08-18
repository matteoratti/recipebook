# frozen_string_literal: true

class ActivityType < ApplicationRecord
  has_many :activity_logs, dependent: :destroy
end
