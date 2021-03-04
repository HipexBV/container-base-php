# PHP Container base image
This project contains the Hipex PHP container base image. This image follows the configuration used at the Hipex platform.

Versions:
- 7.2
  - [ghcr.io/hipexbv/container-base-php/7.2-fpm](https://github.com/orgs/HipexBV/packages/container/package/container-base-php%2F7.2-fpm)
  - [ghcr.io/hipexbv/container-base-php/7.2-fpm-devel](https://github.com/orgs/HipexBV/packages/container/package/container-base-php%2F7.2-fpm-devel)
  - [ghcr.io/hipexbv/container-base-php/7.2-cli](https://github.com/orgs/HipexBV/packages/container/package/container-base-php%2F7.2-cli)
  - [ghcr.io/hipexbv/container-base-php/7.2-cli-devel](https://github.com/orgs/HipexBV/packages/container/package/container-base-php%2F7.2-fpm-devel)
- 7.3
  - [ghcr.io/hipexbv/container-base-php/7.3-fpm](https://github.com/orgs/HipexBV/packages/container/package/container-base-php%2F7.3-fpm)
  - [ghcr.io/hipexbv/container-base-php/7.3-fpm-devel](https://github.com/orgs/HipexBV/packages/container/package/container-base-php%2F7.3-fpm-devel)
  - [ghcr.io/hipexbv/container-base-php/7.3-cli](https://github.com/orgs/HipexBV/packages/container/package/container-base-php%2F7.3-cli)
  - [ghcr.io/hipexbv/container-base-php/7.3-cli-devel](https://github.com/orgs/HipexBV/packages/container/package/container-base-php%2F7.3-fpm-devel)
- 7.4
  - [ghcr.io/hipexbv/container-base-php/7.4-fpm](https://github.com/orgs/HipexBV/packages/container/package/container-base-php%2F7.4-fpm)
  - [ghcr.io/hipexbv/container-base-php/7.4-fpm-devel](https://github.com/orgs/HipexBV/packages/container/package/container-base-php%2F7.4-fpm-devel)
  - [ghcr.io/hipexbv/container-base-php/7.4-cli](https://github.com/orgs/HipexBV/packages/container/package/container-base-php%2F7.4-cli)
  - [ghcr.io/hipexbv/container-base-php/7.4-cli-devel](https://github.com/orgs/HipexBV/packages/container/package/container-base-php%2F7.4-fpm-devel)
- 8.0
  - [ghcr.io/hipexbv/container-base-php/8.0-fpm](https://github.com/orgs/HipexBV/packages/container/package/container-base-php%2F8.0-fpm)
  - [ghcr.io/hipexbv/container-base-php/8.0-fpm-devel](https://github.com/orgs/HipexBV/packages/container/package/container-base-php%2F8.0-fpm-devel)
  - [ghcr.io/hipexbv/container-base-php/8.0-cli](https://github.com/orgs/HipexBV/packages/container/package/container-base-php%2F8.0-cli)
  - [ghcr.io/hipexbv/container-base-php/8.0-cli-devel](https://github.com/orgs/HipexBV/packages/container/package/container-base-php%2F8.0-fpm-devel)


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
FROM ghcr.io/hipexbv/container-base-php/fpm-devel:v1.0.0

# Containers run non privileged
USER root
RUN install-php-extensions amqp mongodb
USER app

EXPOSE 9000

COPY --from=build /app /app
```


## Devel version
The devel versions will have composer and xdebug installed.
