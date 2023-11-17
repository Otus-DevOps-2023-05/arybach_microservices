FROM ubuntu:16.04

# Install dependencies
RUN apt-get update \
    && apt-get install -y curl gnupg2 \
    && \curl -sSL https://rvm.io/pkuczynski.asc | gpg --import - \
    && \curl -sSL https://get.rvm.io | bash -s stable \
    && /bin/bash -l -c "rvm requirements" \
    && /bin/bash -l -c "rvm install 2.6.0" \
    && /bin/bash -l -c "rvm use 2.6.0 --default" \
    && /bin/bash -l -c "gem install bundler"

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/
RUN /bin/bash -l -c "bundle install --deployment" # Installing gems to a local path
ADD . $APP_HOME

# Use environment variables for service hostnames and ports
ENV POST_SERVICE_HOST=${POST_SERVICE_HOST} POST_SERVICE_PORT=${POST_SERVICE_PORT} \
    COMMENT_SERVICE_HOST=${COMMENT_SERVICE_HOST} COMMENT_SERVICE_PORT=${COMMENT_SERVICE_PORT}

CMD ["/bin/bash", "-l", "-c", "bundle exec puma"]
