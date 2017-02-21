module UserHelper
  def display_has_danger(field)
    if @user.errors.messages[field].present?
      'error'
    end
  end

  def display_form_control_feedback(field)
    messages = @user.errors.messages[field]
    return "" unless messages.present?
    messages.map { |msg| content_tag(:div, "#{field.to_s.humanize} #{msg}") }.join.html_safe
  end
end
