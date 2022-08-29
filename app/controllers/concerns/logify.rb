# frozen_string_literal: true

module Logify
  def self.included(base)
    base.class_eval do
      private

      def logify_action
        return if (400...600).include?(response.status)

        entity = instance_variable_get("@#{controller_name.singularize}")

        current_user.logify(entity, "#{action_name}_#{controller_name}", @notify_to, entity.previous_changes.except(:updated_at))
      end
    end
  end
end
