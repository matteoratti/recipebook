# frozen_string_literal: true

module FilterByStatus
  def self.included(base)
    base.class_eval do
      scope :filter_by_status, ->(status) { where(status: status) }
    end
  end
end
