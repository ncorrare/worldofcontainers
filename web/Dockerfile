FROM httpd:2.4
MKDIR /app
MKDIR /config
RUN git clone https://github.com/ncorrare/worldofcontainers.git /app
COPY /app/web/index.html /usr/local/apache2/htdocs/
COPY /app/web/js /usr/local/apache2/htdocs/
COPY /app/web/css /usr/local/apache2/htdocs/
VOLUME /config
COPY /config/config.js /usr/local/apache2/htdocs/js/
