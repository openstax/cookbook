FROM ruby:3.2.2-bullseye AS runtime-env

ARG bundler_version
ARG EASYBAKE_VERSION=1.2.8

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    software-properties-common \
    zlib1g-dev \
    shellcheck \
    && rm -rf /var/lib/apt/lists/*

# Install a quick colorized prompt and turn on ls coloring
RUN git clone https://github.com/nojhan/liquidprompt.git ~/liquidprompt && \
    echo '[[ $- = *i* ]] && source ~/liquidprompt/liquidprompt' >>~/.bashrc && \
    mkdir -p ~/.config && \
    echo 'export LP_HOSTNAME_ALWAYS=1' >>~/.config/liquidpromptrc && \
    echo 'export LP_USER_ALWAYS=-1' >>~/.config/liquidpromptrc && \
    sed -i "/color=auto/"' s/# //' ~/.bashrc && \
    sed -i "/alias ls/,/lA/"' s/# //' ~/.bashrc

WORKDIR /code
COPY . /code/

RUN gem install bundler --no-document --version $bundler_version && \
    bundle install && \
    gem install lefthook && \
    bundle config set no-cache 'true' && \
    bundle config set silence_root_warning 'true' && \
    echo "Generating YARD documentation for gems (this can be slow)..." && \
    bundle exec yard gems --quiet
