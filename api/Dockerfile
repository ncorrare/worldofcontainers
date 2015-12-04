FROM ruby:2.2.1
MAINTAINER Nicolas Corrarello <nicolas@corrarello.com>

RUN apt-get update && \
    apt-get install -y net-tools

    # Install gems
    ENV APP_HOME /app
    ENV HOME /root
    RUN mkdir $APP_HOME
    WORKDIR $APP_HOME
    COPY Gemfile* $APP_HOME/
    RUN bundle install

    # Upload source
    COPY . $APP_HOME

    # Start server
    ENV PORT 3000
    EXPOSE 3000
    CMD ["ruby", "countriesapi.rb"]
