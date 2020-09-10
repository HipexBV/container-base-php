#!/bin/bash

set -e

# Enable extensions
install-php-extensions \
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
