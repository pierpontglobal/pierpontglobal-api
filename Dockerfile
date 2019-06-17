FROM ruby:2.5.1

ENV AWS_REGION=us-east-1
ENV AWS_BUCKET=pierpontglobal-api-images
ENV AWS_ACCESS_KEY_ID=AKIAI566CCS72L4YKO4A
ENV AWS_SECRET_ACCESS_KEY=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

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs python3 python3-pip
RUN pip3 install awscli --upgrade
RUN aws ecr get-login --region $AWS_REGION --no-include-email

RUN mkdir /pierpontglobal-api
WORKDIR /pierpontglobal-api

COPY Gemfile /pierpontglobal-api/Gemfile
COPY Gemfile.lock /pierpontglobal-api/Gemfile.lock

COPY . /pierpontglobal-api

RUN gem install bundler -v 1.17.3
RUN bundle check || bundle install

EXPOSE 3000

CMD bundle exec rails db:create; bundle exec rails db:migrate; bundle exec rails db:seed; bundle exec rails server -b 0.0.0.0