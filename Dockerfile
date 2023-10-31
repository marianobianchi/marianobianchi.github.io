FROM ruby:3.2-slim

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    ruby-full \
    build-essential \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

RUN gem install bundler

RUN useradd -ms /bin/bash jekyll

USER jekyll
WORKDIR /home/jekyll

COPY --chown=jekyll ./docs/Gemfile ./docs/Gemfile.lock ./

ENV GEM_HOME="/home/jekyll/gems" PATH="/home/jekyll/gems/bin:${PATH}"

RUN bundle install

COPY --chown=jekyll ./docs .

EXPOSE 5000

CMD [ "jekyll", "serve", "--host", "0.0.0.0", "--port", "5000" ]
