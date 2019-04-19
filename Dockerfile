FROM ruby:2.5.1

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN curl -o /usr/local/bin/ecs-cli https://s3.amazonaws.com/amazon-ecs-cli/ecs-cli-linux-amd64-latest
RUN chmod +x /usr/local/bin/ecs-cli

RUN mkdir /pierpontglobal-api
WORKDIR /pierpontglobal-api

COPY Gemfile /pierpontglobal-api/Gemfile
COPY Gemfile.lock /pierpontglobal-api/Gemfile.lock

COPY . /pierpontglobal-api

RUN gem install bundler -v 1.17.3
RUN bundle check || bundle install

EXPOSE 3000

CMD bundle exec rails server -b 0.0.0.0