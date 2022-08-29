# frozen_string_literal: true

module ApplicationHelper
  def nested_dom_id(*args)
    args.map { |arg| arg.respond_to?(:to_key) ? dom_id(arg) : arg }.join('_')
  end

  def like_element(likeable, html_options = nil)
    return unless current_user

    html_options ||= {}
    html_options[:class] ||= 'btn btn-success my-2'

    turbo_frame_tag nested_dom_id('button_like', likeable) do
      model_name = likeable.model_name.singular_route_key

      if like_of_current_user(likeable)
        button_to public_send("#{model_name}_like_path", likeable, like_of_current_user(likeable)), method: :delete, class: html_options[:class], form_class: 'd-inline-block' do
          content_tag(:i, '', class: 'bi bi-heart-fill')
        end
      else
        button_to public_send("#{model_name}_likes_path", likeable), class: html_options[:class], form_class: 'd-inline-block' do
          content_tag(:i, '', class: 'bi bi-heart')
        end
      end
    end
  end

  def like_counter(likeable)
    turbo_frame_tag nested_dom_id('counter_like', likeable) do
      "#{likeable.likes.count} likes"
    end
  end
end
