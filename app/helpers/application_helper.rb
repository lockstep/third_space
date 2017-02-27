module ApplicationHelper
  def display_error(obj, field)
    return 'error' if obj.errors.messages[field].present?
  end

  def display_has_danger(obj, field)
    return 'has-danger' if obj.errors.messages[field].present?
  end

  def display_form_control_feedback(obj, field)
    messages = obj.errors.messages[field]
    return "" unless messages.present?
    messages.map { |msg| content_tag(:div, "#{field.to_s.humanize} #{msg}") }.join.html_safe
  end
end
