FROM ruby:2.5.1

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

RUN mkdir /pierpontglobal-api
WORKDIR /pierpontglobal-api

COPY Gemfile /pierpontglobal-api/Gemfile
COPY Gemfile.lock /pierpontglobal-api/Gemfile.lock

RUN gem install bundler
RUN bundle check || bundle install

COPY . /pierpontglobal-api
RUN ["chmod", "+x", "/pierpontglobal-api/bin/start_rails_docker"]

RUN set -x

RUN CONFIGURATION=true rails db:create
RUN CONFIGURATION=true rails db:migrate
RUN CONFIGURATION=true bundle exec sidekiq -c 1 &

CMD bundle exec rails server -b 0.0.0.0