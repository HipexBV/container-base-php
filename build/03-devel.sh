#!/bin/bash

set -e

if [[ "$IMAGE_VERSION" =~ -devel$ ]]; then
    pecl install xdebug
    docker-php-ext-enable xdebug
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
    apk --update --no-cache add \
        curl \
        git \
        unzip \
        zip \
        git
    docker-php-source delete
fi
