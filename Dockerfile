FROM ruby:2.5-alpine3.7
LABEL maintainer="subicura@subicura.com"
COPY Gemfile* /usr/src/app/
WORKDIR /usr/src/app
RUN bundle install
COPY . /usr/src/app
HEALTHCHECK --interval=10s CMD wget -qO- localhost:4567
EXPOSE 4567
CMD bundle exec ruby app.rb -o 0.0.0.0
