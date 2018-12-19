# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Requirement compliant gems
gem 'minfraud'

# MSM Managers
gem 'authy', '~> 2.7', '>= 2.7.2'
gem 'twilio-ruby', '~> 5.15.0'

gem 'bcrypt'
gem 'figaro'
gem 'jbuilder'
gem 'puma'
gem 'rails'
gem 'redis'

# Run task asynchronously
gem 'rake'
gem 'sidekiq'
gem 'sinatra'

# Database gems
gem 'pg'

# Documentation and good practices
gem 'rubocop-airbnb'

# Logging system for production
gem 'awesome_print'
gem 'rails_semantic_logger'

# Mail senders gems
gem 'sendgrid-ruby'
gem 'smtpapi'

# Storage manager
gem 'paperclip', '~> 6.0.0'

# Authentication | Authorization | Roles manager
gem 'aws-sdk-ecs'
gem 'aws-sdk-elasticsearchservice'
gem 'cancancan'
gem 'devise'
gem 'doorkeeper'
gem 'rolify'

# Elastic | Smart search
gem 'searchkick'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]

  gem 'rspec-rails'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
