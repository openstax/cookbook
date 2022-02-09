FROM ruby:2.6.6-buster AS runtime-env

ARG bundler_version
ARG EASYBAKE_VERSION=1.2.8

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git \
    vim \
    openssh-server \
    build-essential \
    wget \
    software-properties-common \
    python3 \
    python-dev \
    python-setuptools \
    python-pip \
    python-wheel \
    zlib1g-dev \
    libicu-dev \
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

# Install cnx-easybake (if for any reason we end up using more python
# dependencies this can get pulled out into a requirements.txt)
RUN pip install cnx-easybake==${EASYBAKE_VERSION}

WORKDIR /code
COPY . /code/

RUN gem install bundler --no-document --version $bundler_version && \
    bundle install && \
    gem install solargraph && \
    gem install lefthook && \
    bundle config set no-cache 'true' && \
    bundle config set silence_root_warning 'true' && \
    echo "Generating YARD documentation for gems (this can be slow)..." && \
    bundle exec yard gems --quiet
