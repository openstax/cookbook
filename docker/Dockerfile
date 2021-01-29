FROM ubuntu:18.04

# Install bundler and all the versions of gems we need. Notes:
#
# 1) Git is required for bundler since we may sometimes have a
#    gem pulled from github.  Also nice for development to have it
#    installed.
# 2) Python is required for cnx-easybake

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git \
    build-essential \
    software-properties-common \
    python3 \
    python-pip \
    ruby-full \
    ruby-dev \
    zlib1g-dev \
    && \
    gem install bundler --no-document && \
    gem install byebug --no-document && \
    bundle config set no-cache 'true' && \
    bundle config set silence_root_warning 'true' && \
    rm -rf /var/lib/apt/lists/*

# Install gems which are needed to run each recipe
COPY . /code
RUN /code/scripts/install_used_gem_versions
