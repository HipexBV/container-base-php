ARG PHP_VERSION=7.4-cli

FROM php:${PHP_VERSION}-alpine
LABEL maintainer="Hipex.io <info@hipex.io>"

ARG IMAGE_VERSION

USER root

# Install extension dependencies
RUN apk --update --no-cache add --virtual .ext-deps \
        bzip2-dev \
        libjpeg-turbo-dev \
        libpng-dev \
        freetype-dev \
        geoip-dev \
        wget \
        gmp-dev \
        imagemagick-dev \
        icu-dev \
        tidyhtml-dev \
        libxslt-dev \
        yaml-dev \
        libzip-dev \
        libsodium-dev \
        curl-dev

# Configure and install dependencies
RUN docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
    && docker-php-ext-configure opcache --enable-opcache \
    && docker-php-ext-install -j$(nproc) \
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
RUN apk --update --no-cache add --virtual .build-deps $PHPIZE_DEPS \
    && pecl install -o -f \
        geoip-1.1.1 \
        igbinary \
        imagick \
        redis \
        yaml \
        sodium

# Install workarround zlib
RUN docker-php-ext-install zlib \
    ; cp /usr/src/php/ext/zlib/config0.m4 /usr/src/php/ext/zlib/config.m4 \
    && docker-php-ext-install zlib

# Cleanup build dependencies
RUN docker-php-source delete \
    && apk del .build-deps

# Enable extensions
RUN docker-php-ext-enable \
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

# Install dev dependencies
RUN echo "$IMAGE_VERSION" | grep "devel" \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && apk --update --no-cache add \
        curl \
        git \
        unzip \
        zip \
        git \
    && docker-php-source delete
