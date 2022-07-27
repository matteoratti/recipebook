# frozen_string_literal: true

module ApplicationHelper
  def nested_dom_id(*args)
    args.map { |arg| arg.respond_to?(:to_key) ? dom_id(arg) : arg }.join('_')
  end

  def like_element(likeable)
    path = "#{likeable.model_name.singular_route_key}_likes_path"

    turbo_frame_tag nested_dom_id('button_like') do
      button_to 'Like', public_send(path, likeable), class: 'btn btn-success my-2', form_class: 'd-inline-block' unless current_user_liked?(likeable)
    end
  end

  def like_counter(likeable)
    turbo_frame_tag nested_dom_id('counter_like') do
      "#{likeable.likes.count} likes"
    end
  end
end
