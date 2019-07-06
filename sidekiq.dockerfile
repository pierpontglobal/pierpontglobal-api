FROM ruby:2.5.1

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

RUN mkdir /sidekiq_worker
WORKDIR /sidekiq_worker

COPY . /sidekiq_worker

RUN gem install bundler
RUN bundle check || bundle install

CMD bundle exec sidekiq -q $QUEUENAME,2 -q scrap_heavy_vehicles -c 1