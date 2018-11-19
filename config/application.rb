require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :develo pment, or :production.
Bundler.require(*Rails.groups)

module PierpontglobalApi
  class Application < Rails::Application

    config.autoload_paths << "#{Rails.root}/lib"
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Only loads a smaller set of middleware suitable for api only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.

    config.action_cable.allowed_request_origins = [/http:\/\/*/, /https:\/\/*/]

    config.api_only = true
    config.log_level = :debug

    Minfraud.configure do |c|
      c.license_key = ENV['MAX_MIND_KEY']
      c.user_id     = ENV['MAX_MIND_USER']
    end

    config.lograge.enabled = true
    config.lograge.formatter = Lograge::Formatters::Logstash.new
    config.lograge.logger = LogStashLogger.new(type: :tcp, host: ENV['LOGSTASH_HOST'], port: 5000)
    config.lograge.custom_options = lambda do |event|
      exceptions = %w[controller action format registration]
      {
        params: event.payload[:params].except(*exceptions)
      }
    end

    unless ENV['CONFIGURATION']
      config.after_initialize do
        unless User.find_by_username('admin')
          admin_user = User.new(
            email: 'support@pierpontglobal.com',
            username: 'admin',
            password: ENV['ADMIN_PASSWORD'],
            phone_number:  ENV['ADMIN_CONTACT']
          )
          admin_user.skip_confirmation_notification!
          admin_user.save!
          admin_user.add_role(:admin)
        end
      end
    end
  end
end
