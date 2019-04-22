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

    Thread.new do
      app_name = 'PierpontglobalApi'

      config.semantic_logger.add_appender(
        appender: ElasticsearchAWS.new(
          url: 'https://search-kibana-dunwccauo3hrpqnh2amsv3vofm.us-east-1.es.amazonaws.com',
          index: 'pierpontglobal-api',
          access_key_id: ENV['AWS_ACCESS_KEY_ID'],
          secrete_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
          region: ENV['AWS_REGION']
        )
      )
      config.log_tags = {
        ip: :remote_ip
      }
      config.semantic_logger.application = app_name
    end

    Minfraud.configure do |c|
      c.license_key = ENV['MAX_MIND_KEY']
      c.user_id = ENV['MAX_MIND_USER']
    end

    unless ENV['CONFIGURATION']
      config.after_initialize do
        # INITIATING BASIC CONFIGURATIONS
        GeneralConfiguration.first_or_create!(key: 'pull_release', value: '1')

        # DEFAULT ADMIN USER CREATION
        unless User.find_by_username('admin')
          admin_user = User.new(
            email: 'support@pierpontglobal.com',
            username: 'admin',
            password: ENV['ADMIN_PASSWORD'],
            phone_number: ENV['ADMIN_CONTACT']
          )
          admin_user.skip_confirmation_notification!
          admin_user.save!
          admin_user.add_role(:admin)
          admin_user.add_role(:super_admin)
        end

        # DEFAULT WORKING LOCATIONS
        locations = [
          { "name": 'Manheim Fort Lauderdale', "mh_id": 162 },
          { "name": 'Manheim Palm Beach', "mh_id": 205 },
          { "name": 'Manheim Orlando', "mh_id": 139 },
          { "name": 'Manheim Tampa', "mh_id": 151 },
          { "name": 'Manheim St Pete', "mh_id": 197 },
          { "name": 'Manheim Central Florida', "mh_id": 126 }
        ]

        locations.each do |location|
          ::Location.where(location).first_or_create!
        end

        Thread.new do
          release = GeneralConfiguration.find_by(key: 'pull_release').value.to_i
          release_range = release - 2
          ::Car.where("release >= #{release_range}").reindex unless ENV['NOREINDEX']
        end
      end
    end
  end
end
