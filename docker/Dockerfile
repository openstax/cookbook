# TODO: merge conflicts

<<<<<<< HEAD
FROM ruby:2.6-slim

ARG bundler_version
=======
FROM ruby:2.6.6-buster AS runtime-env

ARG EASYBAKE_VERSION=1.2.8
# Install bundler and all the versions of gems we need. Notes:
#
# 1) Git is required for bundler since we may sometimes have a
#    gem pulled from github.  Also nice for development to have it
#    installed.
# 2) Python is required for cnx-easybake
>>>>>>> remote-recipes/main

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git \
<<<<<<< HEAD
    vim \
    openssh-server \
    build-essential \
=======
    build-essential \
    software-properties-common \
    python3 \
    python-dev \
    python-setuptools \
    python-pip \
    python-wheel \
    zlib1g-dev \
    libicu-dev \
    && \
    gem install bundler --no-document && \
    gem install byebug --no-document && \
    bundle config set no-cache 'true' && \
    bundle config set silence_root_warning 'true' && \
    rm -rf /var/lib/apt/lists/*

# Install cnx-easybake (if for any reason we end up using more python
# dependencies this can get pulled out into a requirements.txt)
RUN pip install cnx-easybake==${EASYBAKE_VERSION}

# Install gems which are needed to run each recipe
COPY . /code
RUN /code/scripts/install_used_gem_versions
WORKDIR /code

# The following dev-env stage is mostly useful for devcontainer runs in VSCode

FROM runtime-env AS dev-env

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    vim \
    openssh-server \
>>>>>>> remote-recipes/main
    wget \
    && rm -rf /var/lib/apt/lists/*

# Install a quick colorized prompt and turn on ls coloring
RUN git clone https://github.com/nojhan/liquidprompt.git ~/liquidprompt && \
    echo '[[ $- = *i* ]] && source ~/liquidprompt/liquidprompt' >>~/.bashrc && \
    mkdir -p ~/.config && \
    echo 'export LP_HOSTNAME_ALWAYS=1' >>~/.config/liquidpromptrc && \
    echo 'export LP_USER_ALWAYS=-1' >>~/.config/liquidpromptrc && \
    sed -i "/color=auto/"' s/# //' ~/.bashrc && \
    sed -i "/alias ls/,/lA/"' s/# //' ~/.bashrc

# VSCode Live Share libraries
RUN wget -O ~/vsls-reqs https://aka.ms/vsls-linux-prereq-script && chmod +x ~/vsls-reqs && ~/vsls-reqs

<<<<<<< HEAD
WORKDIR /code
COPY . /code/

RUN gem install bundler --no-document --version $bundler_version && \
    gem install solargraph && \
    gem install lefthook && \
    bundle config set no-cache 'true' && \
    bundle config set silence_root_warning 'true' && \
    bundle install && \
    echo "Generating YARD documentation for gems (this can be slow)..." && \
    bundle exec yard gems --quiet
=======
RUN gem install solargraph && \
    gem install lefthook && \
    gem install rspec && \
    gem install rubocop
>>>>>>> remote-recipes/main
