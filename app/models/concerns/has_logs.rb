# frozen_string_literal: true

module HasLogs
  def self.included(base)
    base.class_eval do

      has_many :activity_logs, as: :target, dependent: :nullify

    end
  end
end
