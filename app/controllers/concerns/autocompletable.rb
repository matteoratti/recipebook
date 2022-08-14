# frozen_string_literal: true

module Autocompletable
  def self.included(base)
    base.class_eval do
      def autocomplete
        @results = controller_name.classify.constantize.filter_by_name(params[:q])
        render partial: 'shared/autocomplete', formats: :html
      end
    end
  end
end
