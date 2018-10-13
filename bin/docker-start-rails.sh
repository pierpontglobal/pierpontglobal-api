#!/usr/bin/env bash

set -x

gem install bundler
bundle check || bundle install

CONFIGURATION=true rails db:create
CONFIGURATION=true rails db:migrate

bundle exec puma -C config/puma.rb &
bundle exec sidekiq -c 1