module UserHelper
  def display_has_danger(field)
    if @user.errors.messages[field].present?
      'has-danger'
    end
  end

  def display_form_control_danger(field)
    @user.errors.messages[field].present? ? 'form-control-danger' : ''
  end

  def display_form_control_feedback(field)
    if @user.errors.messages[field].present?
      content_tag :div, class: 'form-control-feedback' do
        "#{field.to_s.humanize} can't be blank."
      end
    end
  end
end
