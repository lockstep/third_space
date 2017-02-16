module DeviseHelper
  def devise_error_messages!
    return "" unless devise_error_messages?

    resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join.html_safe
  end

  def devise_error_messages?
    !resource.errors.empty?
  end

end
