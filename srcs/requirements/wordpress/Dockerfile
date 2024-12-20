FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y \
    php7.4-fpm \
    php7.4-mysql \
    php7.4-mysqli \
    php7.4-json \
    php7.4-curl \
    php7.4-dom \
    php7.4-exif \
    php7.4-fileinfo \
    php7.4-mbstring \
    php7.4-xml \
    php7.4-zip \
    wget \
    unzip \
    mariadb-client \
    php-pear \
    php7.4-dev \
    gcc \
    make \
    php7.4-redis \
    redis-tools \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

RUN mkdir -p /var/www/html /run/php

WORKDIR /var/www/html
RUN wget https://wordpress.org/wordpress-5.9.tar.gz && \
    tar -xzf wordpress-5.9.tar.gz && \
    cp -r wordpress/* . && \
    rm -rf wordpress wordpress-5.9.tar.gz

COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY wp-config.php /var/www/html/
COPY /conf/redis-cache-enable.php /tmp/redis-cache-enable.php

COPY tools/init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh

RUN chown -R www-data:www-data /var/www/html /run/php

RUN wget https://downloads.wordpress.org/plugin/redis-cache.2.5.4.zip && \
    unzip redis-cache.2.5.4.zip -d /var/www/html/wp-content/plugins/ && \
    rm redis-cache.2.5.4.zip

RUN sed -i 's/;daemonize = yes/daemonize = no/g' /etc/php/7.4/fpm/php-fpm.conf

RUN php -m | grep redis

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/init.sh"]