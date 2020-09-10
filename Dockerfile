ARG PHP_VERSION=7.4-cli

FROM php:${PHP_VERSION}-buster
LABEL maintainer="Hipex.io <info@hipex.io>"

ARG IMAGE_VERSION
ARG PHP_VERSION

USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        openssh-client \
        rsync \
        git \
        patch \
        bash \
        ca-certificates \
        wget \
        curl \
        openssl \
        g++ \
        autoconf \
        make \
        libtool \
        docker \
        gnupg \
        zip \
    && rm -rf /var/lib/apt/lists/*

# Install php extensions
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/

# Install PHP extensions
RUN install-php-extensions \
    bcmath \
    bz2 \
    exif \
    gd \
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
    pcntl

# Prepare dev image
RUN if echo "$IMAGE_VERSION" | grep -q '-devel$'; then echo "Preparing development image" \
    && install-php-extensions xdebug \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    ; fi

# Prepare user
RUN mkdir /app \
    && addgroup -S app -g 5000 \
    && adduser \
        -S \
        -h /app \
        -s /bin/shell \
        -u 5000 \
        app app \
    && chown app:app /app

# Copy config files
COPY files/all/. /

# Prepare environment
USER app
WORKDIR /app
ENTRYPOINT ["hipex-entry-point.sh"]
