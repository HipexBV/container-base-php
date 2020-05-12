#!/bin/bash

set -e
set -o xtrace

docker-php-ext-configure opcache --enable-opcache

if [[ "$PHP_VERSION" =~ ^7.[0-3] ]]; then
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
else
    docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/
fi

if [[ "$PHP_VERSION" =~ ^7.0 ]]; then
    ln -s /usr/include/tidybuffio.h /usr/include/buffio.h
fi

# Install build dependencies
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

# shellcheck disable=SC2086
apk --update --no-cache add --virtual .build-deps ${PHPIZE_DEPS} \
  git

# Compile and install snappy
git clone --recursive --depth=1 https://github.com/kjdev/php-ext-snappy.git
cd php-ext-snappy
phpize
./configure
make
make install

# Install pecl extensions
pecl install -o -f \
    geoip-1.1.1 \
    igbinary \
    imagick \
    redis \
    yaml \
    sodium

# Install workaround zlib
docker-php-ext-install zlib || true
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
    pcntl \
    snappy
