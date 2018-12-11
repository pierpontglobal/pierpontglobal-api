FROM ruby:2.5.1

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

RUN mkdir /sidekiq_worker
WORKDIR /sidekiq_worker

COPY Gemfile /sidekiq_worker/Gemfile
COPY Gemfile.lock /sidekiq_worker/Gemfile.lock

COPY . /sidekiq_worker

RUN gem install bundler
RUN bundle check || bundle install

CMD CONFIGURATION=true bundle exec sidekiq -q car_pulling -c 15