# PHP Container base image
This project contains the Hipex PHP container base image. This image follows the configuration used at the Hipex platform.

Packages build are:
- [ghcr.io/hipexbv/container-base-php/fpm](https://github.com/orgs/HipexBV/packages/container/package/container-base-php%2Ffpm)
- [ghcr.io/hipexbv/container-base-php/fpm-devel](https://github.com/orgs/HipexBV/packages/container/package/container-base-php%2Ffpm-devel)
- [ghcr.io/hipexbv/container-base-php/cli](https://github.com/orgs/HipexBV/packages/container/package/container-base-php%2Fcli)
- [ghcr.io/hipexbv/container-base-php/cli-devel](https://github.com/orgs/HipexBV/packages/container/package/container-base-php%2Ffpm-devel)

Versions:
- 7.2
- 7.3
- 7.4
- 8.0


## Usage
The suggested way to use the images is by building your image on top. For example

```Dockerfile
FROM ghcr.io/hipexbv/container-base-php/fpm-devel:v1.0.0 as build

# Copy app code
COPY / /app
RUN composer install \
        --no-progress \
        --no-dev \
        --no-suggest \
        --optimize-autoloader \
        --prefer-dist

FROM ghcr.io/hipexbv/container-base-php/fpm-devel:v1.0.0

EXPOSE 9000

COPY --from=build /app /app
```


### Adding extensions
Extensions are installed using https://github.com/mlocati/docker-php-extension-installer so it is very easy to
use your own extensions.

```Dockerfile
FROM ghcr.io/hipexbv/container-base-php/fpm-devel:v1.0.0

RUN install-php-extensions amqp

EXPOSE 9000

COPY --from=build /app /app
```


## Devel version
The devel versions will have composer and xdebug installed.
