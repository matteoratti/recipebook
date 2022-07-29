# frozen_string_literal: true

module ApplicationHelper
  def nested_dom_id(*args)
    args.map { |arg| arg.respond_to?(:to_key) ? dom_id(arg) : arg }.join('_')
  end

  def like_element(likeable)
    turbo_frame_tag nested_dom_id('button_like') do
      model_name = likeable.model_name.singular_route_key

      if current_likeable(likeable)
        button_to public_send("#{model_name}_like_path", likeable, current_likeable(likeable)), method: :delete, class: 'btn btn-success my-2', form_class: 'd-inline-block' do
          content_tag(:i, '', class: 'bi bi-heart-fill')
        end
      else
        button_to public_send("#{model_name}_likes_path", likeable), class: 'btn btn-success my-2', form_class: 'd-inline-block' do
          content_tag(:i, '', class: 'bi bi-heart')
        end
      end
    end
  end

  def like_counter(likeable)
    turbo_frame_tag nested_dom_id('counter_like') do
      "#{likeable.likes.count} likes"
    end
  end
end
