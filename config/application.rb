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
    config.paperclip_defaults = {
      storage: :s3,
      s3_credentials: {
        bucket: ENV.fetch('S3_BUCKET'),
        access_key_id: ENV.fetch('S3_KEY'),
        secret_access_key: ENV.fetch('S3_SECRET'),
        s3_region: 'us-east-1'
      },
      styles: { medium: "300x300>", thumb: "200x200>" },
      default_url: "/images/:style/missing.png",
      path: "#{Rails.root}/public/:basename.:extension",
      url: "/:attachment/:basename.:extension"
    }
  end
end
