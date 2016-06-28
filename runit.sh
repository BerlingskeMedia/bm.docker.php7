#!/bin/bash
set -e

USER_ID=${USER_ID:-"www-data"}
GROUP_ID=${GROUP_ID:-$USER_ID}

if [[ "$1" == 'php-fpm' || "$1" == 'php-fpm7.0' ]]; then
    shift 1
    echo "Running php-fpm7.0 $@"

    # Set user and group for php-fpm process
    if ! [ "$USER_ID" == 'www-data' ] ; then 
        sed -i -e "s/^user = .*/user = $USER_ID/"    /etc/php/7.0/fpm/pool.d/symfony.pool.conf
        sed -i -e "s/^group = .*/group = $GROUP_ID/" /etc/php/7.0/fpm/pool.d/symfony.pool.conf
    fi

    exec php-fpm7.0 "$@"

elif [[ "$1" == 'php' || "$1" == 'php7.0' ]]; then 
    shift 1
    echo "Running cli: php7.0 $@"
    exec gosu $USER_ID:$GROUP_ID php7.0 "$@"

else 
    echo "Running command: $@"
    exec "$@"   

fi



