# frozen_string_literal: true

require_relative 'boot'

require 'rails'
require 'socket'
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'action_cable/engine'
require 'rails/test_unit/railtie'
require 'rails_semantic_logger'
require 'net/http'
require 'uri'
require 'json'
require 'set'
require 'aws-sdk-elasticsearchservice'
require 'elasticsearch'
require 'faraday_middleware/aws_sigv4'
require './lib/notification_handler'
require './lib/worker_handler'

require_relative '../app/Appenders/elasticsearch_aws'

Bundler.require(*Rails.groups)

module PierpontglobalApi
  # Rails configuration
  class Application < Rails::Application
    config.autoload_paths += %W[#{config.root}/lib]
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
  end
end
