ARG PHP_VERSION=7.4-cli

################
# New relic build steps
################
FROM php:${PHP_VERSION} AS newrelic-build

ENV NEWRELIC_VERSION=9.15.0.293

WORKDIR /build
RUN export PHP_API_VERSION=$(php -i | grep 'PHP API' | sed -e 's/PHP API => //') \
    && curl -fL -o "/build/php_agent.tar.gz" "https://download.newrelic.com/php_agent/release/newrelic-php5-${NEWRELIC_VERSION}-linux.tar.gz" \
    && tar -xvf php_agent.tar.gz \
    && cp "/build/newrelic-php5-${NEWRELIC_VERSION}-linux/agent/x64/newrelic-${PHP_API_VERSION}.so" /build/newrelic.so

################
# New relic build steps
################
FROM php:${PHP_VERSION}
LABEL maintainer="Hipex.io <info@hipex.io>"

ARG IMAGE_VERSION
ARG PHP_VERSION

ENV NEWRELIC_ENABLED="false"
ENV NEWRELIC_LICENSE_KEY=""
ENV NEWRELIC_APP_NAME="Hipex container app"

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
        unzip \
        gettext-base \
    && rm -rf /var/lib/apt/lists/*

# Install php extensions
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/
COPY --from=newrelic-build /build/newrelic.so /usr/local/lib/php/extensions/newrelic.so

RUN export PHP_API_VERSION=$(php -i | grep 'PHP API' | sed -e 's/PHP API => //') \
    && mv /usr/local/lib/php/extensions/newrelic.so "/usr/local/lib/php/extensions/no-debug-non-zts-${PHP_API_VERSION}/newrelic.so"

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
RUN if echo "$IMAGE_VERSION" | grep '\-devel'; then echo "Preparing development image" \
    && install-php-extensions xdebug \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=1.10.17 \
    && composer global require hirak/prestissimo --ignore-platform-reqs \
    ; fi

# Prepare user
RUN mkdir /app \
    && addgroup --system app --gid 5000 \
    && adduser \
        --system \
        --home /app \
        --shell /bin/shell \
        --uid 5000 \
        --gid 5000 \
        app \
    && chown app:app /app

# Copy config files
COPY files/all/. /

# Prepare environment
USER app
WORKDIR /app
ENTRYPOINT ["hipex-entry-point.sh"]
