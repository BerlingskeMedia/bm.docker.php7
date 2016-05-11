#!/bin/bash

if [ -z "${USER_ID}" ]; then
       USER_ID=1000
fi

usermod -u $USER_ID www-data
groupmod -u $USER_ID www-data

while true; do
    /etc/init.d/php7.0-fpm start
done
