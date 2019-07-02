FROM ruby:2.5.1

RUN mkdir /sidekiq_worker
WORKDIR /sidekiq_worker

COPY . /sidekiq_worker

RUN gem install bundler
RUN bundle check || bundle install

CMD bundle exec sidekiq -q $QUEUENAME -c 10; bundle exec sidekiq -q scrab_heavy_vehicles -r ./app/jobs/scrab_heavy_vehicles.rb