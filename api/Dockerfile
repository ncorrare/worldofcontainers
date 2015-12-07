FROM ruby:latest
MAINTAINER Nicolas Corrarello <nicolas@corrarello.com>

RUN apt-get update && \
    apt-get install -y net-tools libsasl2-dev

    # Install gems
    ENV APP_HOME /app
    ENV HOME /root
    RUN mkdir $APP_HOME
    WORKDIR $APP_HOME
    RUN curl https://raw.githubusercontent.com/ncorrare/worldofcontainers/master/api/Gemfile > $APP_HOME/Gemfile 
    RUN bundle install
    RUN curl https://raw.githubusercontent.com/ncorrare/worldofcontainers/master/api/countriesapi.rb > $APP_HOME/api.rb 
    VOLUME /config:/config
    COPY /config/config.yaml $APP_HOME/config.yaml
    # Start server
    ENV PORT 3000
    EXPOSE 3000
    CMD ["ruby", "api.rb"]
