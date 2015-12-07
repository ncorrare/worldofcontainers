FROM httpd:latest
RUN mkdir /app
RUN mkdir /config
RUN git clone https://github.com/ncorrare/worldofcontainers.git /app
RUN ln -s /app/web/index.html /usr/local/apache2/htdocs/
RUN ln -s /app/web/js /usr/local/apache2/htdocs/
RUN ln -s /app/web/css /usr/local/apache2/htdocs/
RUN ln -s /config/config.js /usr/local/apache2/htdocs/js/
