FROM ubuntu:xenial

RUN apt-get update && \
    apt-get install -y ant && \
    apt-get install -y git && \
    apt-get install -y curl && \
    apt-get purge -y php5* && \
    apt-get install -y php7.0 && \
    apt-get install -y php7.0-dev && \
    apt-get install -y php7.0-curl && \
    apt-get install -y php7.0-intl && \
    apt-get install -y php-mysql && \
    apt-get install -y php-redis && \
    apt-get install -y php-bcmath && \
    apt-get install -y php-mbstring && \
    apt-get install -y mc && \
    apt-get install -y vim

RUN yes '' | pecl install apcu_bc-beta

RUN echo 'extension=apcu.so' >> /etc/php/7.0/cli/php.ini && \
    echo 'extension=apc.so' >> /etc/php/7.0/cli/php.ini && \
    echo 'extension=apcu.so' >> /etc/php/7.0/fpm/php.ini && \
    echo 'extension=apc.so' >> /etc/php/7.0/fpm/php.ini

ADD opcache.ini /etc/php/7.0/fpm/conf.d/

ADD symfony.pool.conf /etc/php/7.0/fpm/pool.d/

RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

RUN usermod -u 1000 www-data
RUN groupmod -g 1000 www-data

ADD runit.sh /

CMD ["/runit.sh"]

WORKDIR /var/www
