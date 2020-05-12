ARG PHP_VERSION=7.4-cli

FROM php:${PHP_VERSION}-alpine
LABEL maintainer="Hipex.io <info@hipex.io>"

ARG IMAGE_VERSION
ARG PHP_VERSION

USER root

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
        curl-dev \
        bash \
        gettext

# Run build scripts
COPY build /build
RUN for FILE in /build/*.sh; do echo "Running ${FILE}"; bash "${FILE}" -H || exit 1; done \
    && rm -Rf /build

# Copy config files
COPY files/all/. /

# Prepare environment
USER app
WORKDIR /app
ENTRYPOINT ["hipex-entry-point.sh"]
