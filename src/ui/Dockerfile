FROM ubuntu:16.04

# Install dependencies
RUN apt-get update && \
    apt-get install -y curl gnupg2 && \
    gpg2 --keyserver hkp://keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB && \
    \curl -sSL https://get.rvm.io | bash -s stable

# Install Ruby 2.6.0
RUN /bin/bash -l -c "rvm requirements"
RUN /bin/bash -l -c "rvm install 2.6.0"
RUN /bin/bash -l -c "rvm use 2.6.0 --default"
RUN /bin/bash -l -c "gem install bundler"

# Set up your application
ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME
COPY Gemfile* $APP_HOME/
RUN /bin/bash -l -c "bundle install"

COPY . $APP_HOME
RUN /bin/bash -l -c "gem install puma"

ENV POST_SERVICE_HOST=post POST_SERVICE_PORT=5000 COMMENT_SERVICE_HOST=comment COMMENT_SERVICE_PORT=9292
CMD ["/bin/bash", "-l", "-c", "puma"]
