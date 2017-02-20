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
      'has-danger'
    end
  end

  def display_devise_form_control_danger(field)
    resource.errors.messages[field].present? ? 'form-control-danger' : ''
  end

  def display_devise_form_control_feedback(field)
    if resource.errors.messages[field].present?
      content_tag :div, class: 'form-control-feedback' do
        "#{field.to_s.humanize} can't be blank."
      end
    end
  end
end
