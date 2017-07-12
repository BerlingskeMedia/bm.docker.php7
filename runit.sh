#!/bin/bash

if [ -z "${USER_ID}" ]; then
       USER_ID=1000
fi

usermod -u $USER_ID www-data
groupmod -g $USER_ID www-data

echo "Starting supervisor:"
/usr/bin/supervisord -c /etc/supervisor/supervisord.conf

echo "Starting cron:"
cron

mkdir -p /run/php/
touch /run/php/php7.0-fpm.sock

php-fpm7.0 -F
