FROM ubuntu:xenial

ENV REFRESHED_AT "2016-06-23 14:04:00"

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get purge -y php5* && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y -q \ 
        ant           \
        git           \
        curl          \
        php7.0        \
        php7.0-dev    \
        php7.0-curl   \
        php7.0-intl   \
        php-mysql     \
		php-redis     \
		php-bcmath    \
		php-mbstring  \
		php-gd        \
		mc            \
		sudo          \
        nodejs        \
        npm           


# gosu is used insted of sudo and exec to ensure the container process get pid 1
RUN curl -o /usr/bin/gosu -fsSL "https://github.com/tianon/gosu/releases/download/1.9/gosu-$(dpkg --print-architecture)" && \
    chmod +x /usr/bin/gosu

RUN curl -sL https://deb.nodesource.com/setup_4.x | bash -
RUN ln -s /usr/bin/nodejs /usr/bin/node

RUN yes '' | pecl install apcu_bc-beta

RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

RUN echo 'extension=apcu.so' >> /etc/php/7.0/cli/php.ini && \
    echo 'extension=apc.so' >> /etc/php/7.0/cli/php.ini && \
    echo 'extension=apcu.so' >> /etc/php/7.0/fpm/php.ini && \
    echo 'extension=apc.so' >> /etc/php/7.0/fpm/php.ini

ADD opcache.ini /etc/php/7.0/mods-available/opcache.ini

ADD symfony.pool.conf /etc/php/7.0/fpm/pool.d/

RUN sed -i -e "s/^error_log =/;error_log =/" /etc/php/7.0/fpm/php-fpm.conf && \
    sed -i -e "s/;daemonize = yes/daemonize = no/" /etc/php/7.0/fpm/php-fpm.conf && \
    sed -i -e "/^;error_log =/ a \
error_log = /proc/self/fd/2 " /etc/php/7.0/fpm/php-fpm.conf 

RUN mkdir -p /run/php/ && \
    touch /run/php/php7.0-fpm.sock

# Cleanup - Remove cache and temporary files - no need to spend storage on cache 
RUN apt-get -y clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 9000 3000

ADD runit.sh /

ENTRYPOINT ["/runit.sh"]

CMD ["php-fpm7.0", "--nodaemonize", "--fpm-config", "/etc/php/7.0/fpm/php-fpm.conf"]

WORKDIR /var/www
