FROM ruby:2.6-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /code
COPY . /code/

RUN gem install bundler
RUN bundle install

# Install other things that make development good
RUN gem install solargraph
RUN bundle exec yard gems

ENTRYPOINT ["/code/docker/entrypoint"]
