require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ThirdSpace
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # remove field_with_errors div when form control has errors
    config.action_view.field_error_proc = Proc.new { |html_tag, instance| html_tag.html_safe }

    # tell ActiveJob to use Sidekiq
    config.active_job.queue_adapter = :sidekiq
  end
end
