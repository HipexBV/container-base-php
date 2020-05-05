#!/bin/bash

set -e

docker-php-ext-configure opcache --enable-opcache

if [[ "$PHP_VERSION" =~ ^7.[23] ]]; then
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
else
    docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/
fi

docker-php-ext-install -j$(nproc) \
    bcmath \
    bz2 \
    exif \
    gd \
    gmp \
    intl \
    mysqli \
    opcache \
    pdo_mysql \
    soap \
    sockets \
    sysvmsg \
    sysvsem \
    sysvshm \
    tidy \
    xmlrpc \
    xsl \
    zip \
    pcntl \
    curl \
    json

# Install PECL extensions
apk --update --no-cache add --virtual .build-deps "${PHPIZE_DEPS}" \
    && pecl install -o -f \
        geoip-1.1.1 \
        igbinary \
        imagick \
        redis \
        yaml \
        sodium

# Install workaround zlib
docker-php-ext-install zlib
cp /usr/src/php/ext/zlib/config0.m4 /usr/src/php/ext/zlib/config.m4
docker-php-ext-install zlib

# Cleanup build dependencies
docker-php-source delete \
apk del .build-deps

# Enable extensions
docker-php-ext-enable \
    bcmath \
    bz2 \
    exif \
    gd \
    geoip \
    gmp \
    igbinary \
    imagick \
    intl \
    mysqli \
    opcache \
    pdo_mysql \
    redis \
    soap \
    sockets \
    sodium \
    sysvmsg \
    sysvsem \
    sysvshm \
    tidy \
    xmlrpc \
    xsl \
    yaml \
    zip \
    zlib \
    json \
    pcntl
