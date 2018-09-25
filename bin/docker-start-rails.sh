#!/usr/bin/env bash

set -x

gem install bundler
bundle check || bundle install

rake db:create
rake db:migrate

bundle exec puma -C config/puma.rb