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

ENV POST_SERVICE_HOST=post POST_SERVICE_PORT=5000 COMMENT_SERVICE_HOST=comment COMMENT_SERVICE_PORT=9292

CMD ["/bin/bash", "-l", "-c", "bundle exec puma"]
