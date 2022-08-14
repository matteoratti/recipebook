# frozen_string_literal: true

module FilterByName
  def self.included(base)
    base.class_eval do
      scope :filter_by_name, ->(search) { where("#{table_name}.name LIKE ?", "%#{search}%") }
    end
  end
end
