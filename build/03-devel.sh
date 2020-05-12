#!/bin/bash

set -e

if [[ "$IMAGE_VERSION" =~ -devel$ ]]; then
    echo "Preparing development image"
else
    echo "Skipped, not a development build"
    exit 0
fi

if [[ "$PHP_VERSION" =~ ^7.[0] ]]; then
    echo "Skipped, xdebug no longer supported for php version"
    exit 0
fi

# Install xdebug
pecl install xdebug
docker-php-ext-enable xdebug

# Install composer
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Extra dependencies
apk --update --no-cache add \
    curl \
    git \
    unzip \
    zip \
    git
