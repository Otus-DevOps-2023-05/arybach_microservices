FROM ruby:2.6.0-alpine

# Install build dependencies
RUN apk add --no-cache build-base

ENV APP_HOME /app

RUN mkdir $APP_HOME

WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/

# Install the required version of Bundler
RUN gem install bundler:1.17.2

# Install the gems specified in the Gemfile
RUN bundle install

COPY . $APP_HOME

ENV COMMENT_DATABASE_HOST=post_db COMMENT_DATABASE=comments

CMD ["puma"]
