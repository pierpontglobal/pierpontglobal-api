FROM ruby:2.5.1

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

RUN mkdir /pierpontglobal-api
WORKDIR /pierpontglobal-api

COPY Gemfile /pierpontglobal-api/Gemfile
COPY Gemfile.lock /pierpontglobal-api/Gemfile.lock

RUN bundle install

COPY . /pierpontglobal-api
RUN ["chmod", "+x", "/pierpontglobal-api/bin/start_rails_docker"]
CMD /pierpontglobal-api/bin/start_rails_docker