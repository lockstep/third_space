require "administrate/base_dashboard"

class InputDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    problem: Field::BelongsTo,
    id: Field::Number,
    lens: Field::String,
    input_type: Field::String,
    input_text: Field::Text,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :problem,
    :lens,
    :input_type,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :problem,
    :lens,
    :input_type,
    :input_text,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :problem,
    :lens,
    :input_type,
    :input_text,
  ].freeze

  # Overwrite this method to customize how inputs are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(input)
    "#{input.lens.titleize.humanize} - #{input.input_type.humanize}"
  end
end
