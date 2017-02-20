module DeviseHelper
  def devise_error_messages!
    return "" unless devise_error_messages?
    resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join.html_safe
  end

  def devise_error_messages?
    !resource.errors.empty?
  end

  def display_devise_has_danger(field)
    if resource.errors.messages[field].present?
      'error'
    end
  end

  def display_devise_form_control_feedback(field)
    messages = resource.errors.messages[field]
    return "" unless messages.present?
    messages.map { |msg| content_tag(:div, "#{field.to_s.humanize} #{msg}") }.join.html_safe
  end

  def display_avatar_error_message(field)
    messages = resource.errors.messages[field]
    return "" unless messages.present?
    content_tag(:div, "#{field.to_s.humanize} #{messages.last}", class: 'error').html_safe
  end
end
