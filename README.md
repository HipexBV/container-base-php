# PHP Container base image
This project contains the Hipex PHP container base image. This image follows the configuration used at the Hipex platform.

Images are pushed to [ghcr.io/hipexbv/container-base-php](https://github.com/orgs/HipexBV/packages/container/package/container-base-php):

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


### Env replace
On start environment variables inside files with the `.hipextemplate` extension are replaced and moved without the extension.
Replacement is done using [envsubst](https://man7.org/linux/man-pages/man1/envsubst.1.html) command.


### Adding extensions
Extensions are installed using https://github.com/mlocati/docker-php-extension-installer so it is very easy to
use your own extensions.

```Dockerfile
FROM ghcr.io/hipexbv/container-base-php:8.0-fpm-devel-1.0.1

# Containers run non privileged
USER root
RUN install-php-extensions amqp mongodb
USER app

EXPOSE 9000

COPY --from=build /app /app
```


## Devel version
The devel versions will have composer and xdebug installed.
