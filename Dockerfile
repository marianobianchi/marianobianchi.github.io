FROM jekyll/jekyll


COPY --chown=jekyll ./docs/Gemfile ./docs/Gemfile.lock ./

RUN bundle install

USER jekyll
COPY --chown=jekyll ./docs .

EXPOSE 5000

CMD [ "jekyll", "serve", "--host", "0.0.0.0", "--port", "5000" ]
