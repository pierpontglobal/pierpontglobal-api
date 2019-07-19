FROM ruby:2.5.1

ENV AWS_REGION=us-east-1
ENV AWS_BUCKET=pierpontglobal-api-images
ENV AWS_ACCESS_KEY_ID=AKIAI566CCS72L4YKO4A
ENV AWS_SECRET_ACCESS_KEY=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

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs python3 python3-pip

RUN apt-get update && apt-get install -yq \
  firefox-esr \
  chromium \
  git-core \
  xvfb \
  xsel=1.2.0-2+b1 \
  unzip \
  python-pytest=3.0.6-1 \
  libgconf2-4=3.2.6-4+b1 \
  libncurses5=6.0+20161126-1+deb9u2 \
  libxml2-dev=2.9.4+dfsg1-2.2+deb9u2 \
  libxslt-dev \
  libz-dev \
  xclip=0.12+svn84-4+b1

RUN pip3 install awscli --upgrade
RUN aws ecr get-login --region $AWS_REGION --no-include-email

RUN mkdir /pierpontglobal-api
WORKDIR /pierpontglobal-api

COPY Gemfile /pierpontglobal-api/Gemfile

COPY . /pierpontglobal-api

RUN gem install bundler -v 1.17.3
RUN bundle check || bundle install

EXPOSE 3000

CMD rm ./tmp/pids/*; bundle exec rails db:create; bundle exec rails db:migrate; bundle exec rails db:seed; bundle exec sidekiq -q default & bundle exec rails server -b 0.0.0.0